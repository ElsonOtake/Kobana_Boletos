ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def path(locale)
    return "" if locale.empty?

    "/#{locale}"
  end

  def valid_id
    @bank_billets = BoletoSimples::BankBillet.all(page: 1, per_page: 1)
    if @bank_billets.empty?
      new_id
    else
      @bank_billets.first.id
    end
  end

  def opened_id
    id = nil
    @bank_billets = BoletoSimples::BankBillet.all
    @bank_billets.each do |bank_billet|
      if bank_billet.status == "opened"
        id = bank_billet.id
        break
      end
    end
    if id.nil?
      new_id
    else
      id
    end
  end

  def new_id
    @bank_billet = BoletoSimples::BankBillet.create(
        amount: 132.99,
        expire_at: Date.today + 15,
        customer_person_name: "Museu do Amanhã",
        customer_cnpj_cpf: "04.393.475/0004-99",
        customer_state: "RJ",
        customer_city_name: "Rio de Janeiro",
        customer_zipcode: "20081240",
        customer_address: "Praça Mauá, 1",
        customer_neighborhood: "Centro"
      )
    if @bank_billet.persisted?
      @bank_billet.id
    else
      puts "Erro :( #{@bank_billet.response_errors} )"
    end
  end
end
