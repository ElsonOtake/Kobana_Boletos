class BoletosController < ApplicationController
  before_action :set_boleto, only: %i(edit show)
  Required = %i(amount expire_at customer_person_name customer_cnpj_cpf customer_state customer_city_name 
                customer_zipcode customer_address customer_neighborhood)
  def index
    # Listar os boletos
    @billets = []
    bank_billets = BoletoSimples::BankBillet.all(page: 1, per_page: 50)
    # puts "Boletos Retornados: #{@bank_billets.count}"
    # puts "Página Anterior: #{BoletoSimples.last_request.links[:prev]}"
    # puts "Próxima Página: #{BoletoSimples.last_request.links[:next]}"
    bank_billets.each do |bank_billet|
      @billets << bank_billet.attributes.slice(:id, :status, *Required)
    end
  end

  def edit
  end

  def show
    # Pegar informações de um boleto
    # @bank_billet = BoletoSimples::BankBillet.find(params[:id])
    # Se o não for encontrado nenhum boleto com o id informado, uma exceção será levantada com a mensagem:
    # Couldn't find BankBillet with 'id'=1
    if @bank_billet.empty?
      redirect_to root_path
    end
  end

  def create
    @bank_billet = BoletoSimples::BankBillet.new()
    @bank_billet.amount = boleto_params[:amount]
    @bank_billet.expire_at = boleto_params[:expire_at]
    @bank_billet.customer_address = boleto_params[:customer_address]
    @bank_billet.customer_city_name = boleto_params[:customer_city_name]
    @bank_billet.customer_cnpj_cpf = boleto_params[:customer_cnpj_cpf]
    @bank_billet.customer_neighborhood = boleto_params[:customer_neighborhood]
    @bank_billet.customer_person_name = boleto_params[:customer_person_name]
    @bank_billet.customer_state = boleto_params[:customer_state]
    @bank_billet.customer_zipcode = boleto_params[:customer_zipcode]
    @bank_billet.save

    if @bank_billet.save
    # if @bank_billet.persisted?
      redirect_to root_path
    else
      puts "Erro :(#{@bank_billet.response_errors})"
      render :new
    end
  end

  def update
    # Cancelar um boleto
    @bank_billet = BoletoSimples::BankBillet.cancel(id: params[:id])
    if @bank_billet.response_errors.empty?
      redirect_to root_path
    else
      puts "Erro :(#{@bank_billet.response_errors})"
      render :edit
    end
  end

  private

  def set_boleto
    begin
      @bank_billet = BoletoSimples::BankBillet.find(params[:id])
    rescue => error
      puts error.message
    end
  end

  def boleto_params
    params.require(:boleto).permit(*Required)
  end
end
