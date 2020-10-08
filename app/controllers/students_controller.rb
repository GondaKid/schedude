class StudentsController < ApplicationController
  def new

  end

  def create
    #Situation student_id=1 exists, and create schedule for it
    redirect_to controller: 'schedules', action: 'new', student_id: 1, data: params[:student][:schedule]
  end

  def show
    @student = Student.find params[:id]
    @grid = ModelsGrid.new(params[:my_report]) do |scope|
      scope.page(params[:page]) # See pagination section
    end
  end

  private
  def student_param
    params[:student][:info] = params[:student][:schedule]
    params.require(:student).permit(:student_id, :info)
  end
end