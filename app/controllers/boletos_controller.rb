class BoletosController < ApplicationController
  before_action :set_boleto, only: %i[ edit show ]
  Required = %i(amount expire_at customer_person_name customer_cnpj_cpf customer_state customer_city_name 
                customer_zipcode customer_address customer_neighborhood)
  
def index
    @boletos = []
    bank_billets = BoletoSimples::BankBillet.all
    bank_billets.each do |bank_billet|
      @boletos << bank_billet.attributes.slice(:id, :status, *Required)
    end
  end

  def show
  end

  def new
    @boleto = Boleto.new
    @cities = []
  end

  def edit
  end

  def create
    boleto= Boleto.new(boleto_params)
    boleto.create
    
    respond_to do |format|
      if boleto.persisted?
        @boleto = boleto.attributes.with_indifferent_access
        format.html { redirect_to root_path, notice: "Boleto criado com sucesso." }
        format.turbo_stream
      else
        # puts "Erro :(#{@bank_billet.response_errors})"
        @cities = CS.cities(boleto_params[:customer_state], :BR)
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    boleto = Boleto.new.cancel(params[:id])
    respond_to do |format|
      if boleto.persisted?
        @boleto = Boleto.new.find(params[:id])
        format.html { redirect_to root_path, notice: "Boleto cancelado com sucesso." }
        format.turbo_stream
      else
        puts "Erro :(#{cancel.response_errors})"
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_boleto
    @boleto = Boleto.new.find(params[:id])
    if @boleto.is_a? String
      flash.notice = @boleto
      redirect_to root_path 
    end
  end

  def boleto_params
    params.require(:boleto).permit(*Required)
  end
end
