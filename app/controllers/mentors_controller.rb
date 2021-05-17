class MentorsController < ApplicationController
  before_action :set_mentor, only: %i[show update destroy]

  # GET /mentors
  def index
    @mentors = Mentor.all
    json_response(@mentors)
  end

  # POST /mentors
  def create
    @mentor = Mentor.create!(mentor_params)
    # `create!` instead of `create` to raise an exception ActiveRecord::RecordInvalid
    json_response(@mentor, :created)
  end

  # GET /mentors/:id
  def show
    json_response(@mentor)
  end

  # PUT /mentors/:id
  def update
    @mentor.update(mentor_params)
    head :no_content
  end

  # DELETE /mentors/:id
  def destroy
    @mentor.destroy
    head :no_content
  end

  private

  def mentor_params
    # whitelist params
    params.permit(:name, :time_zone)
  end

  def set_mentor
    @mentor = Mentor.find(params[:id])
    # ActiveRecord::RecordNotFound. Rescue this exception and return 404
  end
end
