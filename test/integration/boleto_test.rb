require 'test_helper'

class BoletoIntegrationTest < ActionDispatch::IntegrationTest

  test 'consegue abrir a página raiz' do
    get "/"
    assert_select "a", "Criar boleto"
  end

  test 'consegue criar um novo boleto com dados válidos' do
    get "/boletos/new"
    assert_response :success

    post "/boletos", params: {
                       boleto: {
                         amount: 10.99,
                         expire_at: Date.today + 15,
                         customer_person_name: "Integration Test",
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

    assert_equal "Boleto criado com sucesso", flash[:notice]
  end

  test 'não consegue criar um novo boleto com CNPJ inválido' do
    get "/boletos/new"
    assert_response :success

    post "/boletos", params: {
                       boleto: {
                         amount: 10.99,
                         expire_at: "2024-12-12",
                         customer_person_name: "Integration Test",
                         customer_cnpj_cpf: "11.222.333/4567-89",
                         customer_state: "SP",
                         customer_city_name: "São Paulo",
                         customer_zipcode: "01310100",
                         customer_address: "Rua F, Alameda G",
                         customer_neighborhood: "Centro"
                       }
                     }

    assert_response 422 # Unprocessable Entity

    assert_select "h2", "1 erro impede esse boleto de ser salvo:"
    assert_select "li", "- CNPJ/CPF não é um CNPJ ou CPF válido"
  end

  test 'não consegue criar um novo boleto com data no passado' do
    get "/boletos/new"
    assert_response :success

    post "/boletos", params: {
                       boleto: {
                         amount: 10.99,
                         expire_at: Date.today - 15,
                         customer_person_name: "Integration Test",
                         customer_cnpj_cpf: "16.974.923/0001-84",
                         customer_state: "SP",
                         customer_city_name: "São Paulo",
                         customer_zipcode: "01310100",
                         customer_address: "Rua F, Alameda G",
                         customer_neighborhood: "Centro"
                       }
                     }

    assert_response 422 # Unprocessable Entity

    assert_select "h2", "1 erro impede esse boleto de ser salvo:"
    assert_select "li", "- Vencimento não pode ser no passado"
  end

  test 'não consegue criar um novo boleto com valor negativo' do
    get "/boletos/new"
    assert_response :success

    post "/boletos", params: {
                       boleto: {
                         amount: -10.99,
                         expire_at: Date.today + 15,
                         customer_person_name: "Integration Test",
                         customer_cnpj_cpf: "16.974.923/0001-84",
                         customer_state: "SP",
                         customer_city_name: "São Paulo",
                         customer_zipcode: "01310100",
                         customer_address: "Rua F, Alameda G",
                         customer_neighborhood: "Centro"
                       }
                     }

    assert_response 422 # Unprocessable Entity

    assert_select "h2", "1 erro impede esse boleto de ser salvo:"
    assert_select "li", "- Valor deve ser maior ou igual a 1"
  end

  test 'não consegue visualizar o boleto se o id for inválido' do
    get "/boletos/0"
    assert_response :redirect
    
    follow_redirect!
    assert_response :success

    assert_select "div", "404 GET https://api-sandbox.kobana.com.br/v1/bank_billets/0 (Não foi possível encontrar o registro)"
  end

  test 'não consegue cancelar boleto se o id for inválido' do
    get "/boletos/0/edit"
    assert_response :redirect
    
    follow_redirect!
    assert_response :success

    assert_select "div", "404 GET https://api-sandbox.kobana.com.br/v1/bank_billets/0 (Não foi possível encontrar o registro)"
  end

  test 'consegue visualizar e cancelar o boleto abertos se o id for válido' do

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
    id = @boleto.id

    # Visualizar boleto
    get "/boletos/#{id}"
    assert_response :success

    assert_select "a", "Cancelar boleto"
    assert_select "a", "Voltar"

    # Cancelar boleto
    get "/boletos/#{id}/edit"
    assert_response :success

    assert_select "a", "Sim, cancelar"
    assert_select "a", "Mostrar boleto"
    assert_select "a", "Voltar"

    # Confirmar cancelamento
    patch "/boletos/#{id}"

    assert_response :redirect
    follow_redirect!
    assert_response :success

    assert_equal "Boleto cancelado com sucesso", flash[:notice]

    # Visualizar o boleto novamente
    get "/boletos/#{id}"
    assert_response :success

    assert_select "a", "Voltar"

    # Confirmar cancelamento de boleto já cancelado
    patch "/boletos/#{id}"

    assert_response 422 # Unprocessable Entity
  end
end