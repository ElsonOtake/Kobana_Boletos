require 'test_helper'

class BoletoIntegrationTest < ActionDispatch::IntegrationTest

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

    @boleto_default = Boleto.new(params)
    @boleto_default.create
    assert @boleto_default.persisted?
    
    params[:customer_person_name] = "Museu do Amanhã pt"
    @boleto_pt = Boleto.new(params)
    @boleto_pt.create
    assert @boleto_pt.persisted?

    params[:customer_person_name] = "Museu do Amanhã en"
    @boleto_en = Boleto.new(params)
    @boleto_en.create
    assert @boleto_en.persisted?
  end

  { default: "",
    pt: "/pt",
    en: "/en"
  }.each do |key, value|

    # consegue abrir a página raiz com link para o idiomas
    test "can see the index page with a link to language when the locale is #{key.to_s}" do
      get "#{value}/boletos"
      assert_select "a", "English" if key.to_sym == :pt
      assert_select "a", "Português" unless key.to_sym == :pt
    end

    # consegue criar um novo boleto com dados válidos
    test "can create a new bank billet using valid data for #{key.to_s} locale" do
      get "#{value}/boletos/new"
      assert_response :success

      post "#{value}/boletos", params: {
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

      assert_equal "Boleto criado com sucesso", flash[:notice] if key.to_sym == :pt
      assert_equal "Bank Billet successfully created", flash[:notice] unless key.to_sym == :pt
    end


    # não consegue criar um novo boleto com CNPJ inválido
    test "can not create a new bank billet using an invalid CNPJ for #{key.to_s} locale" do
      get "#{value}/boletos/new"
      assert_response :success

      post "#{value}/boletos", params: {
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

      assert_select "h2", "um erro impede esse boleto de ser salvo:" if key.to_sym == :pt
      assert_select "li", "- CNPJ/CPF não é um CNPJ ou CPF válido" if key.to_sym == :pt
      assert_select "h2", "one error prohibited this bank billet from being saved:" unless key.to_sym == :pt
      assert_select "li", "- CNPJ/CPF não é um CNPJ ou CPF válido" unless key.to_sym == :pt
    end

    # não consegue criar um novo boleto com data no passado
    test "can not create a new bank billet using past date for #{key.to_s} locale" do
      get "#{value}/boletos/new"
      assert_response :success

      post "#{value}/boletos", params: {
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

      assert_select "h2", "um erro impede esse boleto de ser salvo:" if key.to_sym == :pt
      assert_select "li", "- Vencimento não pode ser no passado" if key.to_sym == :pt
      assert_select "h2", "one error prohibited this bank billet from being saved:" unless key.to_sym == :pt
      assert_select "li", "- Expire at não pode ser no passado" unless key.to_sym == :pt
    end

    # não consegue criar um novo boleto com valor negativo
    test "can not create a new bank billet using negative value amount for #{key.to_s} locale" do
      get "#{value}/boletos/new"
      assert_response :success

      post "#{value}/boletos", params: {
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

      assert_select "h2", "um erro impede esse boleto de ser salvo:" if key.to_sym == :pt
      assert_select "li", "- Valor deve ser maior ou igual a 1" if key.to_sym == :pt
      assert_select "h2", "one error prohibited this bank billet from being saved:" unless key.to_sym == :pt
      assert_select "li", "- Amount deve ser maior ou igual a 1" unless key.to_sym == :pt
    end

    # não consegue visualizar o boleto se o id for inválido
    test "can not show the bank billet using an invalid id for #{key.to_s} locale" do
      
      get "#{value}/boletos/0"
      assert_response :redirect
      
      follow_redirect!
      assert_response :success

      assert_select "div", "404 GET https://api-sandbox.kobana.com.br/v1/bank_billets/0 (Não foi possível encontrar o registro)"
    end
  
    # consegue visualizar o boleto se o id for válido
    test "can show the bank billet using a valid id for #{key.to_s} locale" do
      id = instance_variable_get("@boleto_#{key.to_s}").id
      
      get "#{value}/boletos/#{id}"
      assert_response :success
      
      assert_select "a", "Cancelar boleto" if key.to_sym == :pt
      assert_select "a", "Voltar" if key.to_sym == :pt
      assert_select "a", "Cancel bank billet" unless key.to_sym == :pt
      assert_select "a", "Back" unless key.to_sym == :pt
    end
  
    # não consegue cancelar boleto se o id for inválido
    test "can not cancel a bank billet using an invalid id for #{key.to_s} locale" do

      get "#{value}/boletos/0/edit"
      assert_response :redirect
      
      follow_redirect!
      assert_response :success

      assert_select "div", "404 GET https://api-sandbox.kobana.com.br/v1/bank_billets/0 (Não foi possível encontrar o registro)"
    end
  
    # consegue cancelar o boleto aberto se o id for válido
    test "can cancel the bank billet using a valid id for #{key.to_s} locale" do
      id = instance_variable_get("@boleto_#{key.to_s}").id

      get "#{value}/boletos/#{id}/edit"
      assert_response :success

      assert_select "a", "Sim, cancelar" if key.to_sym == :pt
      assert_select "a", "Mostrar boleto" if key.to_sym == :pt
      assert_select "a", "Voltar" if key.to_sym == :pt
      assert_select "a", "Yes, I do" unless key.to_sym == :pt
      assert_select "a", "Show bank billet" unless key.to_sym == :pt
      assert_select "a", "Back" unless key.to_sym == :pt

      # request cancellation
      patch "#{value}/boletos/#{id}"

      assert_response :redirect
      follow_redirect!
      assert_response :success

      assert_equal "Boleto cancelado com sucesso", flash[:notice] if key.to_sym == :pt
      assert_equal "Bank Billet successfully canceled", flash[:notice] unless key.to_sym == :pt

      # try to cancel the bank billet again
      patch "#{value}/boletos/#{id}"

      assert_response 422 # Unprocessable Entity
    end
  end
end