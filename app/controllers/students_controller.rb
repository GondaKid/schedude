class StudentsController < ApplicationController
  def new

  end

  def create
    @student = Student.find_by :student_id => params[:student][:student_id]
    return redirect_to student_schedules_path(@student) unless @student.blank?

    @student = Student.new(student_param)
    parsed_schedule = Student.new.parse_data_for_hcmus @student.raw_schedule

    if (parsed_schedule.eql?"DATA_IS_INVAILD") or (parsed_schedule.empty?)
      flash[:errors] = "Schedule is invaild!"
      redirect_to new_student_path
    else
      if @student.save
        redirect_post(overview_student_schedule_path(@student),
          params: {raw_schedule: @student.raw_schedule}, options: {authenticity_token: :auto})
      else
        flash[:errors] = "Please check your student ID!"
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