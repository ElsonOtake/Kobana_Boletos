class BoletosController < ApplicationController
  Required = %i(amount expire_at customer_person_name customer_cnpj_cpf customer_state customer_city_name 
                customer_zipcode customer_address customer_neighborhood)
  def index
    # Listar os boletos
    @billets = []
    bank_billets = BoletoSimples::BankBillet.all(page: 1, per_page: 50)
    bank_billets.each do |bank_billet|
      @billets << bank_billet.attributes.slice(*Required)
    end
  end

  def show
  end

  def create
    @states = CS.states(:BR).keys
    puts "**************** #{params}"
  end

  def cancel
  end
end
