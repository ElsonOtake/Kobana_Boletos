require 'test_helper'

class BoletoIntegrationTest < ActionDispatch::IntegrationTest

  Locales = { default: nil }
  I18n.available_locales.each { |locale| Locales[locale] = locale }

  setup do
    params = {
      amount: 132.99,
      expire_at: Date.today + 15,
      customer_person_name: "Museu do Amanhã",
      customer_cnpj_cpf: "04.393.475/0004-99",
      customer_state: "RJ",
      customer_city_name: "Rio de Janeiro",
      customer_zipcode: "20081240",
      customer_address: "Praça Mauá, 1",
      customer_neighborhood: "Centro"
    }

    Locales.keys.each do |locale|
      params[:customer_person_name] = "Museu do Amanhã #{locale.to_s}"
      instance_variable_set("@boleto_#{locale.to_s}", Boleto.new(params))
      instance_variable_get("@boleto_#{locale.to_s}").create
      assert instance_variable_get("@boleto_#{locale.to_s}").errors?
    end
  end

  Locales.each do |key, value|

    # consegue abrir a página raiz com link para idiomas
    test "can see the index page with a link to language when the locale is #{key.to_s}" do
      get "#{path(value.to_s)}/boletos"
      assert_select "a", "English" if key.to_sym == :pt
      assert_select "a", "Português" unless key.to_sym == :pt
    end

    # consegue criar um novo boleto com dados válidos
    test "can create a new bank billet using valid data for #{key.to_s} locale" do
      get "#{path(value.to_s)}/boletos/new"
      assert_response :success

      post "#{path(value.to_s)}/boletos",
        params: {
          boleto: {
            amount: 10.99,
            expire_at: Date.today + 15,
            customer_person_name: "Integration Test #{key.to_s}",
            customer_cnpj_cpf: "16.974.923/0001-84",
            customer_state: "SP",
            customer_city_name: "São Paulo",
            customer_zipcode: "01310100",
            customer_address: "Rua F, Alameda G",
            customer_neighborhood: "Centro"
          }
        }

      assert_response :redirect
      follow_redirect!
      assert_response :success

      assert_equal I18n.t(:successfully_created, locale: value), flash[:notice]
    end


    # não consegue criar um novo boleto com CNPJ inválido
    test "can not create a new bank billet using an invalid CNPJ for #{key.to_s} locale" do
      get "#{path(value.to_s)}/boletos/new"
      assert_response :success

      post "#{path(value.to_s)}/boletos",
        params: {
          boleto: {
            amount: 10.99,
            expire_at: "2024-12-12",
            customer_person_name: "Integration Test #{key.to_s}",
            customer_cnpj_cpf: "11.222.333/4567-89",
            customer_state: "SP",
            customer_city_name: "São Paulo",
            customer_zipcode: "01310100",
            customer_address: "Rua F, Alameda G",
            customer_neighborhood: "Centro"
          }
        }

      assert_response 422 # Unprocessable Entity

      assert_select "h2", "#{I18n.t(:error, count: 1, locale: value)} #{I18n.t(:error_message, locale: value)}"
      assert_select "li", "- #{I18n.t(:customer_cnpj_cpf, locale: value)} não é um CNPJ ou CPF válido"
    end

    # não consegue criar um novo boleto com data no passado
    test "can not create a new bank billet using past date for #{key.to_s} locale" do
      get "#{path(value.to_s)}/boletos/new"
      assert_response :success

      post "#{path(value.to_s)}/boletos",
        params: {
          boleto: {
            amount: 10.99,
            expire_at: Date.today - 15,
            customer_person_name: "Integration Test #{key.to_s}",
            customer_cnpj_cpf: "16.974.923/0001-84",
            customer_state: "SP",
            customer_city_name: "São Paulo",
            customer_zipcode: "01310100",
            customer_address: "Rua F, Alameda G",
            customer_neighborhood: "Centro"
          }
        }

      assert_response 422 # Unprocessable Entity

      assert_select "h2", "#{I18n.t(:error, count: 1, locale: value)} #{I18n.t(:error_message, locale: value)}"
      assert_select "li", "- #{I18n.t(:expire_at, locale: value)} não pode ser no passado"
    end

    # não consegue criar um novo boleto com valor negativo
    test "can not create a new bank billet using negative value amount for #{key.to_s} locale" do
      get "#{path(value.to_s)}/boletos/new"
      assert_response :success

      post "#{path(value.to_s)}/boletos",
        params: {
          boleto: {
            amount: -10.99,
            expire_at: Date.today + 15,
            customer_person_name: "Integration Test #{key.to_s}",
            customer_cnpj_cpf: "16.974.923/0001-84",
            customer_state: "SP",
            customer_city_name: "São Paulo",
            customer_zipcode: "01310100",
            customer_address: "Rua F, Alameda G",
            customer_neighborhood: "Centro"
          }
        }

      assert_response 422 # Unprocessable Entity

      assert_select "h2", "#{I18n.t(:error, count: 1, locale: value)} #{I18n.t(:error_message, locale: value)}"
      assert_select "li", "- #{I18n.t(:amount, locale: value)} deve ser maior ou igual a 1"
    end

    # não consegue visualizar o boleto se o id for inválido
    test "can not show the bank billet using an invalid id for #{key.to_s} locale" do
      
      get "#{path(value.to_s)}/boletos/0"
      assert_response :redirect
      
      follow_redirect!
      assert_response :success

      assert_select "div", "404 GET https://api-sandbox.kobana.com.br/v1/bank_billets/0 (Não foi possível encontrar o registro)"
    end
  
    # consegue visualizar o boleto se o id for válido
    test "can show the bank billet using a valid id for #{key.to_s} locale" do
      id = instance_variable_get("@boleto_#{key.to_s}").id
      
      get "#{path(value.to_s)}/boletos/#{id}"
      assert_response :success
      
      assert_select "a", I18n.t(:cancel_bank_billet, locale: value)
      assert_select "a", I18n.t(:back, locale: value)
    end
  
    # não consegue cancelar boleto se o id for inválido
    test "can not cancel a bank billet using an invalid id for #{key.to_s} locale" do

      get "#{path(value.to_s)}/boletos/0/edit"
      assert_response :redirect
      
      follow_redirect!
      assert_response :success

      assert_select "div", "404 GET https://api-sandbox.kobana.com.br/v1/bank_billets/0 (Não foi possível encontrar o registro)"
    end
  
    # consegue cancelar o boleto aberto se o id for válido
    test "can cancel the bank billet using a valid id for #{key.to_s} locale" do
      id = instance_variable_get("@boleto_#{key.to_s}").id

      get "#{path(value.to_s)}/boletos/#{id}/edit"
      assert_response :success

      assert_select "a", I18n.t(:yes_i_do, locale: value)
      assert_select "a", I18n.t(:show_bank_billet, locale: value)
      assert_select "a", I18n.t(:back, locale: value)

      # request cancellation
      patch "#{path(value.to_s)}/boletos/#{id}"

      assert_response :redirect
      follow_redirect!
      assert_response :success

      assert_equal I18n.t(:successfully_canceled, locale: value), flash[:notice]

      # try to cancel the bank billet again
      patch "#{path(value.to_s)}/boletos/#{id}"

      assert_response 422 # Unprocessable Entity
    end
  end
end