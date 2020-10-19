class SchedulesController < ApplicationController
  def index
    @student = Student.find_by id: params[:student_id]
    @grid = SchedulesGrid.new(grid_params) do |scope|
      scope.joins(:students).joins(:enrollments).where("students.student_id = '#{@student.student_id}'").distinct.page(params[:page])
    end
  end

  def create
    @student = Student.find params[:student_id]
    schedule = params[:schedule]
    schedule.each do |s|
      subject = Subject.create(code: s[:code], name: s[:name], time: s[:time])
      @student.subjects << subject
    end
    redirect_to student_schedules_path(@student)
  end

  def new
    save_all_subject params[:raw_schedule]

    @student = Student.find params[:student_id]
    @sche = Student.new.get_schedule params[:raw_schedule]
  end

  protected
  def grid_params
    params.fetch(:schedules_grid, {}).permit!
  end

  def save_all_subject raw_schedule
    Student.new.get_subject_by_days(raw_schedule).flatten.each do |s|
      if Subject.find_by(code: s[:code], name: s[:name], time: s[:full_time]).nil?
        Subject.create(code: s[:code], name: s[:name], time: s[:full_time])
      end
    end
  end
end