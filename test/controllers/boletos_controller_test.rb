require "test_helper"

class BoletosControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Criar boleto
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
    @boleto = Boleto.new(params)
    @boleto.create
    assert @boleto.persisted?
  end

  test "deve ir para raiz" do
    get root_url
    assert_response :success
  end

  test "deve ir a lista de boletos" do
    get boletos_url
    assert_response :success
  end

  test "deve ir para criação de boleto" do
    get new_boleto_url
    assert_response :success
  end

  test "deve apresentar o boleto" do
    get boleto_url(@boleto)
    assert_response :success
  end

  test "deve chamar o cancelamento do boleto" do
    get edit_boleto_url(@boleto)
    assert_response :success
  end

  test "deve cancelar o boleto" do
    patch boleto_url(@boleto)
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end

  test "deve criar um boleto" do
    post boletos_url, params: {
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
    assert_response :redirect
    follow_redirect!
    assert_response :success
  end
end
