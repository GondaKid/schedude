class SchedulesController < ApplicationController
  def index
    @student = Student.find_by id: params[:student_id]
    @grid = SchedulesGrid.new(grid_params) do |scope|
      scope.joins(:students).joins(:enrollments).where("students.student_id = '#{@student.student_id}'").distinct.page(params[:page])
    end

    render plain: @student.student_id
  end

  def create
    @student = Student.find params[:student_id]
    schedule = params[:schedule]
    schedule.flatten.each do |s|
      subject = Subject.create(code: s[:code], name: s[:name], time: s[:time])
      @student.subjects << subject
    end
    redirect_to student_schedules_path(@student)
  end

  def new
    save_all_subject params[:raw_schedule]

    @student = Student.find params[:student_id]
    @sche = Student.new.get_schedule params[:raw_schedule]
    redirect_to new_student_path if (@sche.eql?"DATA_IS_INVAILD") || (@sche.eql?"NO_DATA")
  end

  protected
  def grid_params
    params.fetch(:schedules_grid, {}).permit!
  end

  def save_all_subject raw_schedule
    Student.new.get_subject_by_days(raw_schedule).flatten.each do |s|
      formated_time = s[:on] << "(" << s[:time].begin.to_s << "-" << s[:time].end.to_s << ")"
      if Subject.find_by(code: s[:code], name: s[:name], time: formated_time).nil?
        Subject.create(code: s[:code], name: s[:name], time: formated_time)
      end
    end
  end
end