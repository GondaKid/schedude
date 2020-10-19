class StudentsController < ApplicationController
  def new

  end

  def create
    @student = Student.new(student_param)

    parsed_data = Student.new.parse_data_for_hcmus @student.raw_schedule

    if (parsed_data.eql?"DATA_IS_INVAILD") or (parsed_data.empty?)
      flash[:errors] = "Data is invaild!"
      redirect_to new_student_path
    else
      if @student.save
        redirect_to new_student_schedule_path(@student, raw_schedule: @student.raw_schedule)
      else
        flash[:errors] = "Student id cannot be blank!"
        redirect_to new_student_path
      end
    end
  end

  def show
    @student = Student.find params[:id]
    @grid = ModelsGrid.new(params[:my_report]) do |scope|
      scope.page(params[:page]) # See pagination section
    end
  end

  private
  def student_param
    params.require(:student).permit(:student_id, :raw_schedule)
  end
end