class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[ show edit update destroy ]

  # GET /vehicles or /vehicles.json
  def index
    if current_user.role == 'admin'
      @vehicles = Vehicle.all
    else 
      @vehicles = Vehicle.where(:user_id => current_user.id)
    end
  end

  # GET /vehicles/1 or /vehicles/1.json
  def show
  end

  # GET /vehicles/new
  def new
    @vehicle = Vehicle.new
    @vehicle_models = VehicleModel.all
  end

  # GET /vehicles/1/edit
  def edit
    @vehicle_models = VehicleModel.all
  end

  # POST /vehicles or /vehicles.json
  def create
    @vehicle = Vehicle.new(vehicle_params)
    @vehicle.user = current_user
    @vehicle.status = true

    respond_to do |format|
      if @vehicle.save
        format.html { redirect_to vehicles_url, notice: "Vehicle was successfully created." }
        format.json { render :show, status: :created, location: @vehicle }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicles/1 or /vehicles/1.json
  def update
    respond_to do |format|
      if @vehicle.update(vehicle_params)
        format.html { redirect_to vehicles_url, notice: "Vehicle was successfully updated." }
        format.json { render :show, status: :ok, location: @vehicle }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicles/1 or /vehicles/1.json
  def destroy
    @vehicle.destroy

    respond_to do |format|
      format.html { redirect_to vehicles_url, notice: "Vehicle was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def vehicle_params
      params.require(:vehicle).permit(:vehicle_model_id, :user_id, :vehicleRegistrationPlate, :image, :description, :status)
    end
end
