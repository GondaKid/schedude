class StudentsController < ApplicationController
  def new

  end

  def create
    @student = Student.new(student_param)
    @student.save
    redirect_to new_student_schedule_path(@student, raw_schedule: params[:student][:schedule])
  end

  def show
    @student = Student.find params[:id]
    @grid = ModelsGrid.new(params[:my_report]) do |scope|
      scope.page(params[:page]) # See pagination section
    end
  end

  private
  def student_param
    params.require(:student).permit(:student_id)
  end
end