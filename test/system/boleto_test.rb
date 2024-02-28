require 'application_system_test_case'

class BoletoTest < ApplicationSystemTestCase

  test 'visitando a página raiz' do
    visit root_url
    assert_text 'Nome'
    assert_text 'CNPJ/CPF'
    assert_text 'Valor'
    assert_text 'Vencimento'
    assert_text 'Cidade'
    assert_text 'Estado'
    assert_text 'Situação'
    assert_selector "div#flash"
    assert_selector "a.button", text: "Criar boleto"
    assert_selector "table.table"
    assert_selector "tbody#boletos"
    sleep 10
  end

  test 'criando, visualizando e cancelando um boleto' do
    visit root_path
  
    click_on "Criar boleto"

    name = "System Test #{rand(10000)}"
  
    fill_in "Nome", with: name
    fill_in "CNPJ/CPF", with: "04.393.475/0004-99"
    fill_in "Valor", with: 24.5
    fill_in "Vencimento", with: (Date.today + 15).strftime("%m/%d/%Y")
    fill_in "Endereço", with: "Praça Mauá, 1"
    fill_in "CEP", with: "20081240"
    select "RJ", from: "Estado"
    select "Rio de Janeiro", from: "Cidade"
    fill_in "Bairro", with: "Centro"

    click_on "Criar"

    assert_text "Boleto criado com sucesso"

    sleep 2

    click_on name

    assert_text 'Id'
    assert_text 'Nome'
    assert_text name
    assert_text 'CNPJ/CPF'
    assert_text '04.393.475/0004-99'
    assert_text 'Valor'
    assert_text '24.5'
    assert_text 'Vencimento'
    assert_text (Date.today + 15).on_weekday? ? (Date.today + 15).strftime("%Y-%m-%d") : (Date.today + 17).beginning_of_week.strftime("%Y-%m-%d")
    assert_text 'Cidade'
    assert_text 'Rio de Janeiro'
    assert_text 'Estado'
    assert_text 'RJ'
    assert_text 'Situação'
    assert_selector "div#modal-boleto"
    assert_selector "div.columns"
    assert_selector "div.column"
    assert_selector "p.title"
    assert_selector "p.subtitle"
    assert_selector "a.button", text: "Voltar"
    assert_selector "a.button", text: "Cancelar boleto"

    sleep 2

    click_on "Cancelar boleto"

    assert_text "Você tem certeza que quer cancelar o boleto de #{name} no valor de 24.50?"
    assert_selector "p.subtitle"
    assert_selector "a.button", text: "Sim, cancelar"
    assert_selector "a.button", text: "Mostrar boleto"
    assert_selector "a.button", text: "Voltar"

    sleep 2
    
    click_on "Sim, cancelar"

    sleep 2

    assert_text "Boleto cancelado com sucesso"
    
    sleep 2
  end
end