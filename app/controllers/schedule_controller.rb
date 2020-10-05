class ScheduleController < ApplicationController
  def index

  end

  def create
    @sche = Schedule.new params[:data], nil, nil
    @result = @sche.get_schedule
    # render json: @result.to_json
    respond_to do |format|
      format.html {
        render :controller => "schedule", :action => "show"
      }
    end
  end

  def show

  end

end