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
      next if (s.nil?) || (s.empty?)
      subject = Subject.create(code: s[:code], name: s[:name], time: s[:full_time])
      @student.subjects << subject
    end
    redirect_to student_schedules_path(@student)
  end

  def new

  end

  def overview
    save_all_subject params[:raw_schedule]

    @raw_schedule = params[:raw_schedule]
    @student = Student.find params[:student_id]
    @sche = Student.new.get_schedule params[:raw_schedule], params[:exclude]
    @week = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7']
    @excluded_days = params[:exclude].to_json

    respond_to do |format|
      format.html
    end
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