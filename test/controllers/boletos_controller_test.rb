require "test_helper"

class BoletosControllerTest < ActionDispatch::IntegrationTest

  locales = { default: nil }
  I18n.available_locales.each { |locale| locales[locale] = locale }

  locales.each do |key, value|

    # deve ir para raiz
    test "should go to the root path for #{key.to_s} locale" do
      get root_url(locale: value)
      assert_response :success
    end

    # deve ir a lista de boletos
    test "should present the bank billet list for #{key.to_s} locale" do
      get boletos_url(locale: value)
      assert_response :success
    end

    # deve abrir o formulário para criar um boleto
    test "should open the form to create a bank billet for #{key.to_s} locale" do
      get new_boleto_url(locale: value)
      assert_response :success
    end

    # deve apresentar o boleto
    test "should show the bank billet for #{key.to_s} locale" do
      get boleto_url(valid_id, locale: value )
      assert_response :success
    end

    # deve confirmar o cancelamento do boleto
    test "should confirm the bank billet cancel for #{key.to_s} locale" do
      get cancel_boleto_url(opened_id, locale: value )
      assert_response :success
    end

    # deve cancelar o boleto
    test "should cancel a bank billet for #{key.to_s} locale" do
      patch cancel_by_id_boleto_url(opened_id, locale: value )
      assert_response :redirect
      follow_redirect!
      assert_response :success
    end

    # deve criar um boleto
    test "should create a bank billet for #{key.to_s} locale" do
      post boletos_url(locale: value), params: {
        boleto: {
          amount: 132.99,
          expire_at: Date.today + 15,
          customer_person_name: "Museu do Amanhã #{key.to_s}",
          customer_cnpj_cpf: "04.393.475/0004-99",
          customer_state: "RJ",
          customer_city_name: "Rio de Janeiro",
          customer_zipcode: "20081240",
          customer_address: "Praça Mauá, 1",
          customer_neighborhood: "Centro"
        }
      }
      assert_response :redirect
      follow_redirect!
      assert_response :success
    end

    # deve preencher dados a serem alterados no boleto
    test "should fill in the bank billet fields to be updated for #{key.to_s} locale" do
      get boleto_url(opened_id, locale: value )
      assert_response :success
    end

    # deve alterar um boleto
    test "should update a bank billet for #{key.to_s} locale" do
      patch boleto_url(opened_id, locale: value), params: {
        boleto: {
          amount: 164.48,
          expire_at: Date.today + 20
        }
      }
      assert_response :redirect
      follow_redirect!
      assert_response :success
    end
  end
end
