class BoletosController < ApplicationController
  before_action :set_boleto, only: %i[ edit show ]
  
  def index
    @boletos = Boleto.new.all
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
    @boleto= Boleto.new(boleto_params)
    @boleto.create
    
    respond_to do |format|
      if @boleto.persisted?
        format.html { redirect_to root_path, notice: "Boleto criado com sucesso" }
        format.turbo_stream { flash.now[:notice] = "Boleto criado com sucesso" }
      else
        @cities = CS.cities(boleto_params[:customer_state], :BR)
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    boleto = Boleto.new.cancel(params[:id])
    respond_to do |format|
      if boleto.persisted?
        @id = params[:id]
        format.html { redirect_to root_path, notice: "Boleto cancelado com sucesso" }
        format.turbo_stream { flash.now[:notice] = "Boleto cancelado com sucesso" }
      else
        @id = nil
        format.html { render :index, status: :unprocessable_entity }
        format.turbo_stream { flash.now[:notice] = JSON.parse(boleto.response_errors).first.with_indifferent_access[:title] }      
      end
    end
  end

  private

  def set_boleto
    @boleto = Boleto.new.find(params[:id])
    unless @boleto.persisted?
      respond_to do |format|
        message = JSON.parse(boleto.response_errors).first.with_indifferent_access[:title]
        format.html { redirect_to root_path, notice: message }
        format.turbo_stream { flash.now[:notice] = message }
      end
    end
  end

  def boleto_params
    params.require(:boleto).permit(:amount, :expire_at, :customer_person_name, :customer_cnpj_cpf, :customer_state,
                                   :customer_city_name, :customer_zipcode, :customer_address, :customer_neighborhood)
  end
end
