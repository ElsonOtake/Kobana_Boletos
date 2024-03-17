require 'application_system_test_case'

class BoletoTest < ApplicationSystemTestCase
  setup do
    @name = Time.current.strftime("System Test %H%M%S%L")
  end

  locales = { default: nil }
  I18n.available_locales.each { |locale| locales[locale] = locale }

  locales.each do |key, value|

    # visitando a página raiz
    test "visiting the root page at the #{key.to_s} locale" do
      visit root_url(locale: value)
      assert_text I18n.t('boletos.form.customer_person_name', locale: value)
      assert_text I18n.t('boletos.form.customer_cnpj_cpf', locale: value)
      assert_text I18n.t('boletos.form.amount', locale: value)
      assert_text I18n.t('boletos.form.expire_at', locale: value)
      assert_text I18n.t('boletos.form.customer_city_name', locale: value)
      assert_text I18n.t('boletos.form.customer_state', locale: value)
      assert_text I18n.t('boletos.form.status', locale: value)
      assert_selector 'div#flash'
      assert_selector 'a', text: 'Português' unless key.to_sym == :pt
      assert_selector 'a', text: 'English' if key.to_sym == :pt
      assert_selector 'a.button', text: I18n.t('boletos.index.create_bank_billet', locale: value)
      assert_selector 'table.table'
      assert_selector 'tbody#boletos'
      sleep 2
    end

    # trocando o idioma
    test "switching the language from locate #{key.to_s}" do
      visit root_url(locale: value)

      sleep 2

      click_on 'Português' unless key.to_sym == :pt
      click_on 'English' if key.to_sym == :pt

      sleep 2
    end

    # criando, visualizando, alterando e cancelando um boleto
    test "creating, showing, updating and canceling a bank billet at the #{key.to_s} locale" do
      visit root_path(locale: value)

      sleep 2
    
      click_on I18n.t('boletos.index.create_bank_billet', locale: value)
   
      fill_in I18n.t('boletos.form.customer_person_name', locale: value), with: "#{@name} #{key.to_s}"
      fill_in I18n.t('boletos.form.customer_cnpj_cpf', locale: value), with: '04.393.475/0004-99'
      fill_in I18n.t('boletos.form.amount', locale: value), with: 24.5
      fill_in I18n.t('boletos.form.expire_at', locale: value), with: (Date.today + 15).strftime("%m/%d/%Y")
      fill_in I18n.t('boletos.form.customer_address', locale: value), with: 'Praça Mauá, 1'
      fill_in I18n.t('boletos.form.customer_zipcode', locale: value), with: '20081240'
      select 'RJ', from: I18n.t('boletos.form.customer_state', locale: value)
      select 'Rio de Janeiro', from: I18n.t('boletos.form.customer_city_name', locale: value)
      fill_in I18n.t('boletos.form.customer_neighborhood', locale: value), with: 'Centro'

      click_on I18n.t('boletos.form.create', locale: value)

      assert_text I18n.t('boletos.create.successfully_created', locale: value)

      sleep 2

      click_on "#{@name} #{key.to_s}"

      assert_text I18n.t('boletos.form.id', locale: value)
      assert_text I18n.t('boletos.form.customer_person_name', locale: value)
      assert_text "#{@name} #{key.to_s}"
      assert_text I18n.t('boletos.form.customer_cnpj_cpf', locale: value)
      assert_text '04.393.475/0004-99'
      assert_text I18n.t('boletos.form.amount', locale: value)
      assert_text '24.5'
      assert_text I18n.t('boletos.form.expire_at', locale: value)
      assert_text (Date.today + 15).on_weekday? ? (Date.today + 15).strftime("%Y-%m-%d") : (Date.today + 17).beginning_of_week.strftime("%Y-%m-%d")
      assert_text I18n.t('boletos.form.customer_city_name', locale: value)
      assert_text 'Rio de Janeiro'
      assert_text I18n.t('boletos.form.customer_state', locale: value)
      assert_text 'RJ'
      assert_text I18n.t('boletos.form.status', locale: value)
      assert_selector 'div#modal-boleto'
      assert_selector 'div.columns'
      assert_selector 'div.column'
      assert_selector 'p.title'
      assert_selector 'p.subtitle'
      assert_selector 'a.button', text: I18n.t('boletos.form.back', locale: value)
      assert_selector 'a.button', text: I18n.t('boletos.show.edit_bank_billet', locale: value)
      assert_selector 'a.button', text: I18n.t('boletos.show.cancel_bank_billet', locale: value)

      sleep 2

      click_on I18n.t('boletos.show.edit_bank_billet', locale: value)

      fill_in I18n.t('boletos.form.amount', locale: value), with: 32.99
      fill_in I18n.t('boletos.form.expire_at', locale: value), with: (Date.today + 20).strftime("%m/%d/%Y")

      click_on I18n.t('boletos.form.update', locale: value)

      assert_text I18n.t('boletos.update.successfully_updated', locale: value)

      assert_text I18n.t('boletos.form.customer_person_name', locale: value)
      assert_text I18n.t('boletos.form.customer_cnpj_cpf', locale: value)
      assert_text I18n.t('boletos.form.amount', locale: value)
      assert_text I18n.t('boletos.form.expire_at', locale: value)
      assert_text I18n.t('boletos.form.customer_city_name', locale: value)
      assert_text I18n.t('boletos.form.customer_state', locale: value)
      assert_text I18n.t('boletos.form.status', locale: value)
      assert_text "#{@name} #{key.to_s}"
      assert_text '04.393.475/0004-99'
      assert_text '32.99'
      assert_text (Date.today + 20).on_weekday? ? (Date.today + 20).strftime("%Y-%m-%d") : (Date.today + 22).beginning_of_week.strftime("%Y-%m-%d")
      assert_text 'Rio de Janeiro'
      assert_text 'RJ'
      assert_selector 'a.button', text: I18n.t('boletos.bank_billet.cancel', locale: value)

      sleep 2

      click_on "#{@name} #{key.to_s}"

      sleep 2

      click_on I18n.t('boletos.show.cancel_bank_billet', locale: value)

      assert_text I18n.t('boletos.cancel.are_you_sure', name: "#{@name} #{key.to_s}", amount: '32.99', locale: value)
      assert_selector 'p.subtitle'
      assert_selector 'a.button', text: I18n.t('boletos.cancel.yes_i_do', locale: value)
      assert_selector 'a.button', text: I18n.t('boletos.cancel.show_bank_billet', locale: value)
      assert_selector 'a.button', text: I18n.t('boletos.form.back', locale: value)

      sleep 2
      
      click_on I18n.t('boletos.cancel.yes_i_do', locale: value)

      sleep 2

      assert_text I18n.t('boletos.cancel_by_id.successfully_canceled', locale: value)
      
      sleep 2
    end
  end
end