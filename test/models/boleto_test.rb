require "test_helper"

class BoletoTest < ActiveSupport::TestCase

  setup do
    @params = {
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
  end

  # deve criar boleto com valores padrao
  test 'should create an instance with default values' do
    assert true
    boleto = Boleto.new
    assert_nil boleto.id
    assert_nil boleto.amount
    assert_nil boleto.expire_at
    assert_nil boleto.customer_person_name
    assert_nil boleto.customer_cnpj_cpf
    assert_nil boleto.customer_state
    assert_nil boleto.customer_city_name
    assert_nil boleto.customer_zipcode
    assert_nil boleto.customer_address
    assert_nil boleto.customer_neighborhood
    assert_nil boleto.status
    assert_equal boleto.response_errors, "{}"
  end

  # deve criar instância com valores fornecidos
  test 'should create instance with provided values' do
    boleto = Boleto.new(@params)
    assert_nil boleto.id
    assert_equal boleto.amount, 132.99
    assert_equal boleto.expire_at, (Date.today + 15).to_date
    assert_equal boleto.customer_person_name, "Museu do Amanhã"
    assert_equal boleto.customer_cnpj_cpf, "04.393.475/0004-99"
    assert_equal boleto.customer_state, "RJ"
    assert_equal boleto.customer_city_name, "Rio de Janeiro"
    assert_equal boleto.customer_zipcode, "20081240"
    assert_equal boleto.customer_address, "Praça Mauá, 1"
    assert_equal boleto.customer_neighborhood, "Centro"
    assert_nil boleto.status
    assert_equal boleto.response_errors, "{}"
  end

  # deve armazenar amount como Float
  test 'should store amount as Float' do
    boleto = Boleto.new(amount: 10)
    assert_instance_of Float, boleto.amount
  end
  
  # deve armazenar amount como Float se valor for numérico
  test 'should store amount as Float if the value is numeric' do
    boleto = Boleto.new(amount: -9.99)
    assert_instance_of Float, boleto.amount
  end
  
  # deve armazenar amount como Float se string for numérico
  test 'should store amount as Float if numeric string' do
    boleto = Boleto.new(amount: "10")
    assert_instance_of Float, boleto.amount
  end

  # deve armazenar amount zerado se string não for numérico
  test 'should store zero amount if string is not numeric' do
    boleto = Boleto.new(amount: "dez")
    assert_equal boleto.amount, 0.0
  end

  # deve armazenar expire_at como Date
  test 'should store expire_at as Date' do
    boleto = Boleto.new(expire_at: Date.today + 15)
    assert_instance_of Date, boleto.expire_at
  end

  # não deve armazerar o vencimento se a entrada não for data
  test 'should not store the expire_at if the input is not date' do
    boleto = Boleto.new(expire_at: "amanhã")
    assert_nil boleto.expire_at
  end

  # deve criar a instância se a data for válida no passado
  test 'should create an instance if the date is valid in the past' do
    boleto = Boleto.new(expire_at: Date.today - 1)
    assert_instance_of Date, boleto.expire_at
  end

  # não deve armazenar o vencimento se a data for inválida
  test 'should not store the expire_at if date is invalid' do
    boleto = Boleto.new(expire_at: "2030-02-31")
    assert_nil boleto.expire_at
  end

  # deve armazenar os seguintes atributos como String
  test 'should store the following attributes as String' do
    params = {
      customer_person_name: 123,
      customer_cnpj_cpf: 4393475000499,
      customer_state: "RJ",
      customer_city_name: "Rio de Janeiro",
      customer_zipcode: 20081240,
      customer_address: 1,
      customer_neighborhood: "Centro"
    }
    boleto = Boleto.new(params)
    assert_nil boleto.id
    assert_nil boleto.amount
    assert_nil boleto.expire_at
    assert_instance_of String, boleto.customer_person_name
    assert_instance_of String, boleto.customer_cnpj_cpf
    assert_instance_of String, boleto.customer_state
    assert_instance_of String, boleto.customer_city_name
    assert_instance_of String, boleto.customer_zipcode
    assert_instance_of String, boleto.customer_address
    assert_instance_of String, boleto.customer_neighborhood
    assert_nil boleto.status
    assert_equal boleto.response_errors, "{}"
  end

  # deve armazenar o response_errors como JSON String
  test 'should store response_errors as JSON String' do
    message = {:expire_at=>["não pode ficar em branco", "não é uma data válida"]}.to_json
    boleto = Boleto.new
    boleto.response_errors = message
    assert boleto.response_errors.is_a? String
  end

  # deve retornar errors_empty? como verdadeiro se response_errors for um hash vazio
  test 'should return errors_empty? as true if response_errors is an empty hash' do
    boleto = Boleto.new
    assert_equal boleto.response_errors, "{}"
    assert boleto.errors_empty?
  end

  # deve retornar errors_empty? como falso se response_errors não for um hash vazio
  test 'should return errors_empty? as false if response_errors is not an empty hash' do
    message = {:customer_cnpj_cpf=>["não é um CNPJ ou CPF válido"]}.to_json
    boleto = Boleto.new
    boleto.response_errors = message
    assert_not_equal boleto.response_errors, "{}"
    assert_not boleto.errors_empty?
  end

  # deve criar novo boleto a partir de dados da instância
  test 'should create a new bank billet from instance data' do
    boleto = Boleto.new(@params)
    boleto.create
    assert_instance_of Integer, boleto.id
    assert boleto.id > 0
    assert boleto.errors_empty?
    assert_equal boleto.status, "generating"
  end

  # não deve criar novo boleto a partir de dados da instância se o CNPJ/CPF for invalido
  test 'should not create a new bank billet from instance data if the CNPJ/CPF is invalid' do
    @params[:customer_cnpj_cpf] = "11.222.333/4567-89"
    boleto = Boleto.new(@params)
    boleto.create
    assert_not boleto.errors_empty?
    assert_equal JSON.parse(boleto.response_errors)["customer_cnpj_cpf"], ["não é um CNPJ ou CPF válido"]
  end

  # não deve criar novo boleto a partir de dados da instância se o amount for invalido
  test 'should not create a new bank billet from instance data if the amount is invalid' do
    @params[:amount] = -9.99
    boleto = Boleto.new(@params)
    boleto.create
    assert_not boleto.errors_empty?
    assert_equal JSON.parse(boleto.response_errors)["amount"], ["deve ser maior ou igual a 1"]
  end

  # não deve criar novo boleto a partir de dados da instância se a data for no passado
  test 'should not create a new bank billet from instance data if the date is in the past' do
    @params[:expire_at] = Date.today - 15
    boleto = Boleto.new(@params)
    boleto.create
    assert_not boleto.errors_empty?
    assert_equal JSON.parse(boleto.response_errors)["expire_at"], ["não pode ser no passado"]
  end

  # deve retornar lista de boletos
  test 'should present a list of bank billets' do
    id = valid_id # create a bank billet if none
    boletos = Boleto.new.all
    assert boletos.count > 0
    assert_instance_of Array, boletos
    assert_instance_of Boleto, boletos.first
    assert_instance_of Boleto, boletos.last
  end

  # deve recuperar valores do boleto criado a partir de id válido
  test 'should retrieve values from the bank billet by a valid id' do
    id = valid_id
    boleto = Boleto.new.find(id)
    assert_instance_of Boleto, boleto
    assert_equal boleto.id, id
    assert_instance_of Float, boleto.amount
    assert_instance_of Date, boleto.expire_at
    assert_instance_of String, boleto.customer_person_name
    assert_instance_of String, boleto.customer_cnpj_cpf
    assert_instance_of String, boleto.customer_state
    assert_instance_of String, boleto.customer_city_name
    assert_instance_of String, boleto.customer_zipcode
    assert_instance_of String, boleto.customer_address
    assert_instance_of String, boleto.customer_neighborhood
    assert_equal boleto.response_errors, "{}"
  end

  # não deve recuperar valores do boleto se o id for inválido
  test 'should not retrieve bank billet values if the id is invalid' do
    boleto = Boleto.new.find(0)
    assert_not boleto.errors_empty?
    assert_equal JSON.parse(boleto.response_errors).first["title"], "404 GET https://api-sandbox.kobana.com.br/v1/bank_billets/0 (Não foi possível encontrar o registro)"
  end

  # deve cancelar o boleto se o id for válido e não permitir cancelar boleto já cancelado
  test 'should cancel the bank billet if the ID is valid and should not allow cancel a bank billet that has already been canceled' do
    id = opened_id
    boleto = Boleto.new.cancel(id)
    assert boleto.errors_empty?
    cancel = Boleto.new.cancel(id)
    assert_not cancel.errors_empty?
    assert_equal JSON.parse(cancel.response_errors).first["title"], "Boleto não pode ser cancelado para o status canceled"
    assert_equal JSON.parse(cancel.response_errors).first["code"], "unprocessable_entity"
  end

  # 'não deve cancelar o boleto se o id for inválido'
  test 'should not cancel the bank billet if the ID is invalid' do
    boleto = Boleto.new.cancel(0)
    assert_not boleto.errors_empty?
    assert_equal JSON.parse(boleto.response_errors).first["title"], "404 PUT https://api-sandbox.kobana.com.br/v1/bank_billets/0/cancel (Não foi possível encontrar o registro)"
  end

  # deve alterar vencimento e valor do boleto em aberto a partir de dados da instância
  test 'should update the opened bank billet expire at and amount from instance data' do
    params = {
      amount: 164.48,
      expire_at: Date.today + 20
    }
    id = opened_id
    aux = Boleto.new(params)
    aux.update(id)
    boleto = Boleto.new.find(id)
    assert_equal boleto.id, id
    assert_equal boleto.amount, 164.48
    assert_equal boleto.expire_at, (Date.today + 20).on_weekday? ? (Date.today + 20).to_date : (Date.today + 22).beginning_of_week
    assert_equal boleto.response_errors, "{}"   
  end

  # não deve alterar o boleto em aberto a partir de dados da instância se o valor for negativo
  test 'should not update the opened bank billet from instance data if the amount has a negative value' do
    params = {
      amount: -100.8,
      expire_at: Date.today + 20
    }
    id = opened_id
    boleto = Boleto.new(params)
    boleto.update(id)
    assert_not boleto.errors_empty?
    assert_equal JSON.parse(boleto.response_errors)["amount"], ["deve ser maior ou igual a 1"]
  end

  # não deve alterar o boleto em aberto a partir de dados da instância se o vencimento for no passado
  test 'should not update the opened bank billet from instance data if the expire at is in the past' do
    params = {
      amount: 164.48,
      expire_at: Date.today - 2
    }
    id = opened_id
    boleto = Boleto.new(params)
    boleto.update(id)
    assert_not boleto.errors_empty?
    assert_equal JSON.parse(boleto.response_errors)["expire_at"], ["não pode ser no passado"]
  end
end