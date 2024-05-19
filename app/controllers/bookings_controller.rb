class BookingsController < ApplicationController
  before_action :set_booking, only: %i[ show edit update destroy ]

  # GET /bookings or /bookings.json
  def index
    @bookings = Booking.all
  end

  # GET /bookings/1 or /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
    @parking_slots = ParkingSlot.where(:status => false)
    @vehicles = Vehicle.where(:user_id => current_user.id)
  end

  # GET /bookings/1/edit
  def edit
    @parking_slots = ParkingSlot.where(:status => false)
    @vehicles = Vehicle.where(:user_id => current_user.id)
  end

  # POST /bookings or /bookings.json
  def create
    @booking = Booking.new(booking_params)
    @booking.user = current_user

    respond_to do |format|
      if @booking.save
        if @booking.endTime.present?
          @price = @booking.parking_slot.price
          @duration = @booking.duration
          @amount = @price * @duration

          @payment = Payment.new(
            booking_id: @booking.id,
            totalTime: @duration,
            totalPrice: @amount, 
            paymentType: 'credit'
          )

          if @payment.save
            format.html { redirect_to booking_url(@booking), notice: "Booking and payment were successfully created." }
            format.json { render :show, status: :created, location: @booking }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @payment.errors, status: :unprocessable_entity }
          end
        else
          format.html { redirect_to booking_url(@booking), notice: "Booking was successfully created. Payment will be created once end time is set." }
          format.json { render :show, status: :created, location: @booking }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookings/1 or /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        if @booking.endTime.present?
          @price = @booking.parking_slot.price
          @duration = @booking.duration
          @amount = @price * @duration

          @payment = Payment.new(
            booking_id: @booking.id,
            totalTime: @duration,
            totalPrice: @amount, 
            paymentType: 'credit'
          )

          if @payment.save
            format.html { redirect_to booking_url(@booking), notice: "Booking and payment were successfully created." }
            format.json { render :show, status: :created, location: @booking }
          else
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: @payment.errors, status: :unprocessable_entity }
          end
        else
          format.html { redirect_to booking_url(@booking), notice: "Booking was successfully updated." }
          format.json { render :show, status: :ok, location: @booking }
        end
        # format.html { redirect_to booking_url(@booking), notice: "Booking was successfully updated." }
        # format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1 or /bookings/1.json
  def destroy
    @booking.destroy

    respond_to do |format|
      format.html { redirect_to bookings_url, notice: "Booking was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def booking_params
      params.require(:booking).permit(:parking_slot_id, :vehicle_id, :user_id, :startTime, :endTime, :status)
    end

    
end
