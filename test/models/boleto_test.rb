require "test_helper"

class BoletoTest < ActiveSupport::TestCase

  test 'deve criar boleto com valores padrao' do
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

  test 'deve criar boleto com valores fornecidos' do
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
    boleto = Boleto.new(params)
    assert_nil boleto.id
    assert_equal boleto.amount, 132.99
    assert_equal boleto.expire_at, (Date.today + 15).on_weekday? ? (Date.today + 15).to_date : (Date.today + 17).beginning_of_week
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

  test 'deve armazenar amount como Float' do
    boleto = Boleto.new(amount: 10)
    assert_instance_of Float, boleto.amount
  end
  
  test 'deve armazenar amount como Float se valor for numérico' do
    boleto = Boleto.new(amount: -9.99)
    assert_instance_of Float, boleto.amount
  end
  
  test 'deve armazenar amount como Float se string for numérico' do
    boleto = Boleto.new(amount: "10")
    assert_instance_of Float, boleto.amount
  end

  test 'não deve armazenar amount zerado se string não for numérico' do
    boleto = Boleto.new(amount: "dez")
    assert_equal boleto.amount, 0.0
  end

  test 'deve armazenar expire_at como Date' do
    boleto = Boleto.new(expire_at: Date.today + 15)
    assert_instance_of Date, boleto.expire_at
  end

  test 'não deve armazenar expire_at se não for data' do
    boleto = Boleto.new(expire_at: "amanhã")
    assert_nil boleto.expire_at
  end

  test 'deve armazenar expire_at se a data for válida no passado' do
    boleto = Boleto.new(expire_at: Date.today - 1)
    assert_instance_of Date, boleto.expire_at
  end

  test 'não deve armazenar expire_at se a data for inválida' do
    boleto = Boleto.new(expire_at: "2030-02-31")
    assert_nil boleto.expire_at
  end

  test 'deve armazenar atributos como String' do
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
    assert boleto.customer_person_name.is_a? String
    assert boleto.customer_cnpj_cpf.is_a? String
    assert boleto.customer_state.is_a? String
    assert boleto.customer_city_name.is_a? String
    assert boleto.customer_zipcode.is_a? String
    assert boleto.customer_address.is_a? String
    assert boleto.customer_neighborhood.is_a? String
    assert_nil boleto.status
    assert_equal boleto.response_errors, "{}"
  end

  test 'deve armazenar o response_errors como JSON String' do
    message = {:expire_at=>["não pode ficar em branco", "não é uma data válida"]}.to_json
    boleto = Boleto.new
    boleto.response_errors = message
    assert boleto.response_errors.is_a? String
  end

  test 'deve retornar persisted? como verdadeiro se response_errors for um hash vazio' do
    boleto = Boleto.new
    assert_equal boleto.response_errors, "{}"
    assert boleto.persisted?
  end

  test 'deve retornar persisted? como falso se response_errors não for um hash vazio' do
    message = {:customer_cnpj_cpf=>["não é um CNPJ ou CPF válido"]}.to_json
    boleto = Boleto.new
    boleto.response_errors = message
    assert_not_equal boleto.response_errors, "{}"
    assert_not boleto.persisted?
  end

  test 'deve criar novo boleto a partir de dados da instância' do
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
    boleto = Boleto.new(params)
    boleto.create
    assert boleto.id.is_a? Integer
    assert boleto.id > 0
    assert boleto.persisted?
    assert_equal boleto.status, "generating"
  end

  test 'não deve criar novo boleto a partir de dados da instância se o CNPJ/CPF for invalido' do
    params = {
      amount: 132.99,
      expire_at: Date.today + 15,
      customer_person_name: "Museu do Amanhã",
      customer_cnpj_cpf: "11.222.333/4567-89",
      customer_state: "RJ",
      customer_city_name: "Rio de Janeiro",
      customer_zipcode: "20081240",
      customer_address: "Praça Mauá, 1",
      customer_neighborhood: "Centro"
    }
    boleto = Boleto.new(params)
    boleto.create
    assert_not boleto.persisted?
    assert_not_equal boleto.response_errors, "{}"
  end

  test 'não deve criar novo boleto a partir de dados da instância se o amount for invalido' do
    params = {
      amount: -9.99,
      expire_at: Date.today + 15,
      customer_person_name: "Museu do Amanhã",
      customer_cnpj_cpf: "04.393.475/0004-99",
      customer_state: "RJ",
      customer_city_name: "Rio de Janeiro",
      customer_zipcode: "20081240",
      customer_address: "Praça Mauá, 1",
      customer_neighborhood: "Centro"
    }
    boleto = Boleto.new(params)
    boleto.create
    assert_not boleto.persisted?
  end

  test 'não deve criar novo boleto a partir de dados da instância se a data for no passado' do
    params = {
      amount: 132.99,
      expire_at: Date.today - 15,
      customer_person_name: "Museu do Amanhã",
      customer_cnpj_cpf: "04.393.475/0004-99",
      customer_state: "RJ",
      customer_city_name: "Rio de Janeiro",
      customer_zipcode: "20081240",
      customer_address: "Praça Mauá, 1",
      customer_neighborhood: "Centro"
    }
    boleto = Boleto.new(params)
    boleto.create
    assert_not boleto.persisted?
  end

  test 'deve retornar lista de boletos' do
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
    boleto = Boleto.new(params)
    boleto.create
    assert boleto.persisted?
    boletos = Boleto.new.all
    assert boletos.count > 0
    assert_instance_of Array, boletos
    assert_instance_of Boleto, boletos.first
    assert_instance_of Boleto, boletos.last
  end

  test 'deve recuperar valores do boleto criado a partir do id' do
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
    boleto = Boleto.new(params)
    boleto.create
    assert boleto.persisted?
    novo = Boleto.new.find(boleto.id)
    assert_equal novo.id, boleto.id
    assert_equal novo.amount, 132.99
    assert_equal novo.expire_at, (Date.today + 15).on_weekday? ? (Date.today + 15).to_date : (Date.today + 17).beginning_of_week
    assert_equal novo.customer_person_name, "Museu do Amanhã"
    assert_equal novo.customer_cnpj_cpf, "04.393.475/0004-99"
    assert_equal novo.customer_state, "RJ"
    assert_equal novo.customer_city_name, "Rio de Janeiro"
    assert_equal novo.customer_zipcode, "20081240"
    assert_equal novo.customer_address, "Praça Mauá, 1"
    assert_equal novo.customer_neighborhood, "Centro"
    assert_equal novo.response_errors, "{}"
  end

  test 'não deve recuperar valores do boleto se o id for inválido' do
    boleto = Boleto.new.find(0)
    assert_not boleto.persisted?
    assert_not_equal boleto.response_errors, "{}"
    message = JSON.parse(boleto.response_errors).first.with_indifferent_access
    assert message.has_key? "title"
  end

  test 'deve cancelar o boleto se o id for válido e não permitir cancelar boleto já cancelado' do
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
    boleto = Boleto.new(params)
    boleto.create
    assert boleto.persisted?
    cancel = Boleto.new.cancel(boleto.id)
    assert cancel.persisted?
    repeated_cancel = Boleto.new.cancel(boleto.id)
    assert_not repeated_cancel.persisted?
  end

  test 'não deve cancelar o boleto se o id for inválido' do
    boleto = Boleto.new.cancel(0)
    assert_not boleto.persisted?
    assert_not_equal boleto.response_errors, "{}"
    message = JSON.parse(boleto.response_errors).first.with_indifferent_access
    assert message.has_key? "title"
    assert message.has_key? :title
  end
end