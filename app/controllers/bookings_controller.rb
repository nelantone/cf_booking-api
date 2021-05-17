class BookingsController < ApplicationController
  before_action :set_mentor
  before_action :set_mentor_booking, only: %i[show update destroy]

  # GET /mentors/:mentor_id/bookings
  def index
    json_response(@mentor.bookings)
  end

  # GET /mentors/:mentor_id/bookings/:id
  def show
    json_response(@booking)
  end

  # POST /mentors/:mentor_id/bookings
  def create
    @mentor.bookings.create!(booking_params)
    json_response(@mentor, :created)
  end

  # PUT /mentors/:mentor_id/bookings/:id
  def update
    @booking.update(booking_params)
    head :no_content
  end

  # DELETE /mentors/:mentor_id/bookings/:id
  def destroy
    @booking.destroy
    head :no_content
  end

  private

  def booking_params
    params.permit(:date_time, :call_reason)
  end

  def set_mentor
    @mentor = Mentor.find(params[:mentor_id])
  end

  def set_mentor_booking
    @booking = @mentor.bookings.find_by!(id: params[:id]) if @mentor
  end
end
