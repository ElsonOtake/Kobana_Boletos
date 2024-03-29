require 'test_helper'

class BoletoIntegrationTest < ActionDispatch::IntegrationTest

  Locales = { default: nil }
  I18n.available_locales.each { |locale| Locales[locale] = locale }

  setup do
    @params = {
      boleto: {
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
    }

    @update_params = {
      boleto: {
        amount: 30.5,
        expire_at: Date.today + 20
      }
    }
  end

  Locales.each do |key, value|

    # # consegue abrir a página raiz com link para idiomas
    # test "can see the index page with a link to language when the locale is #{key.to_s}" do
    #   get "#{path(value.to_s)}/boletos"
    #   assert_select "a", "English" if key.to_sym == :pt
    #   assert_select "a", "Português" unless key.to_sym == :pt
    # end

    # # consegue criar um novo boleto com dados válidos
    # test "can create a new bank billet using valid data for #{key.to_s} locale" do
    #   get "#{path(value.to_s)}/boletos/new"
    #   assert_response :success

    #   @params[:boleto][:customer_person_name] = "Integration Test #{key.to_s}"

    #   post "#{path(value.to_s)}/boletos", params: @params

    #   assert_response :redirect
    #   follow_redirect!
    #   assert_response :success

    #   assert_equal I18n.t('boletos.create.successfully_created', locale: value), flash[:notice]
    # end

    # # não consegue criar um novo boleto com CNPJ inválido
    # test "can not create a new bank billet using an invalid CNPJ for #{key.to_s} locale" do
    #   get "#{path(value.to_s)}/boletos/new"
    #   assert_response :success

    #   @params[:boleto][:customer_cnpj_cpf] = "11.222.333/4567-89"

    #   post "#{path(value.to_s)}/boletos", params: @params

    #   assert_response 422 # Unprocessable Entity

    #   assert_select "h2", "#{I18n.t('boletos.form.error', count: 1, locale: value)} #{I18n.t('boletos.form.error_message', locale: value)}"
    #   assert_select "li", "- #{I18n.t('boletos.form.customer_cnpj_cpf', locale: value)} não é um CNPJ ou CPF válido"
    # end

    # # não consegue criar um novo boleto com data no passado
    # test "can not create a new bank billet using past date for #{key.to_s} locale" do
    #   get "#{path(value.to_s)}/boletos/new"
    #   assert_response :success

    #   @params[:boleto][:expire_at] = Date.today - 15

    #   post "#{path(value.to_s)}/boletos", params: @params

    #   assert_response 422 # Unprocessable Entity

    #   assert_select "h2", "#{I18n.t('boletos.form.error', count: 1, locale: value)} #{I18n.t('boletos.form.error_message', locale: value)}"
    #   assert_select "li", "- #{I18n.t('boletos.form.expire_at', locale: value)} não pode ser no passado"
    # end

    # não consegue criar um novo boleto com valor negativo
    test "can not create a new bank billet using negative value amount for #{key.to_s} locale" do
      get "#{path(value.to_s)}/boletos/new"
      assert_response :success

      @params[:boleto][:amount] = -10.99

      post "#{path(value.to_s)}/boletos", params: @params

      assert_response 422 # Unprocessable Entity

      assert_select "h2", "#{I18n.t('boletos.form.error', count: 1, locale: value)} #{I18n.t('boletos.form.error_message', locale: value)}"
      assert_select "li", "- #{I18n.t('boletos.form.amount', locale: value)} deve ser maior ou igual a 1"
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
      id = opened_id
      
      get "#{path(value.to_s)}/boletos/#{id}"
      assert_response :success
      
      assert_select "a", I18n.t('boletos.show.cancel_bank_billet', locale: value)
      assert_select "a", I18n.t('boletos.show.edit_bank_billet', locale: value)
      assert_select "a", I18n.t('boletos.form.back', locale: value)
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
      id = opened_id

      get "#{path(value.to_s)}/boletos/#{id}/cancel"
      assert_response :success

      assert_select "a", I18n.t('boletos.cancel.yes_i_do', locale: value)
      assert_select "a", I18n.t('boletos.cancel.show_bank_billet', locale: value)
      assert_select "a", I18n.t('boletos.form.back', locale: value)

      # request cancellation
      patch "#{path(value.to_s)}/boletos/#{id}/cancel_by_id"

      assert_response :redirect
      follow_redirect!
      assert_response :success

      assert_equal I18n.t('boletos.cancel_by_id.successfully_canceled', locale: value), flash[:notice]

      # try to cancel the bank billet again
      patch "#{path(value.to_s)}/boletos/#{id}/cancel_by_id"

      assert_response 422 # Unprocessable Entity
    end

    # consegue alterar um boleto com dados válidos
    test "can update a bank billet using valid data for #{key.to_s} locale" do
      id = opened_id

      get "#{path(value.to_s)}/boletos/#{id}/edit"
      assert_response :success

      patch "#{path(value.to_s)}/boletos/#{id}", params: @update_params

      assert_response :redirect
      follow_redirect!
      assert_response :success

      assert_equal I18n.t('boletos.update.successfully_updated', locale: value), flash[:notice]
    end

    # não consegue alterar um boleto com data no passado
    test "can not update a bank billet using past date for #{key.to_s} locale" do
      id = opened_id  
    
      get "#{path(value.to_s)}/boletos/#{id}/edit"
      assert_response :success

      @update_params[:boleto][:expire_at] = Date.today - 15

      patch "#{path(value.to_s)}/boletos/#{id}", params: @update_params

      assert_response 422 # Unprocessable Entity

      assert_select "h2", "#{I18n.t('boletos.form.error', count: 1, locale: value)} #{I18n.t('boletos.form.error_message', locale: value)}"
      assert_select "li", "- #{I18n.t('boletos.form.expire_at', locale: value)} não pode ser no passado"
    end

    # não consegue alterar um boleto com valor negativo
    test "can not update a bank billet using negative value amount for #{key.to_s} locale" do
      id = opened_id

      get "#{path(value.to_s)}/boletos/#{id}/edit"
      assert_response :success

      @update_params[:boleto][:amount] = -10.99

      patch "#{path(value.to_s)}/boletos/#{id}", params: @update_params

      assert_response 422 # Unprocessable Entity

      assert_select "h2", "#{I18n.t('boletos.form.error', count: 1, locale: value)} #{I18n.t('boletos.form.error_message', locale: value)}"
      assert_select "li", "- #{I18n.t('boletos.form.amount', locale: value)} deve ser maior ou igual a 1"
    end  
  end
end