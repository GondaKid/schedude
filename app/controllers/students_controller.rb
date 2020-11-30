class StudentsController < ApplicationController
  def new

  end

  def create
    student_id = params[:student][:student_id]
    @student = Student.find_by :student_id => student_id
    if @student.nil?
      @student = Student.new(student_param)
      if @student.save
        flash[:errors] = "Có lỗi xảy ra khi lưu dữ liệu!"
        return redirect_to new_student_path
      end
    else
      return redirect_to student_schedules_path(@student) unless Enrollment.find_by(
                                                          :student_id => @student.id).nil?
    end
    
    schedule = Schedule.new
    list_schedule = schedule.parse_data_for_hcmus(params[:student][:raw_schedule])
    if list_schedule.nil? or params[:student][:raw_schedule].length < 1
      flash[:errors] = "Dữ liệu lịch học không hợp lệ!"
      return redirect_to new_student_path
    else
      list_schedule_id = schedule.save_subject_if_not_exists(list_schedule)
      return redirect_to new_student_schedule_path(@student, sids: list_schedule_id)
    end
  end

  def show
    @student = Student.find params[:id]
  end

  private
  def student_param
    params.require(:student).permit(:student_id, :raw_schedule)
  end
end