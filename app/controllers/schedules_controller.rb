class SchedulesController < ApplicationController
  def index
    @student = Student.find_by id: params[:student_id]
    return redirect_to root_path if @student.nil?
    @week = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7']
    @sche = Subject.joins(:students).joins(:enrollments).where("students.student_id = '#{@student.student_id}'").distinct
  end

  def new
    @student = Student.find params[:student_id]
    @list_subject_id = params[:sids]
    @week = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7']
    @sche = Schedule.new.get_schedule(params[:sids], params[:exclude])
    return redirect_to root_path if @sche.nil?
    @excluded_days = params[:exclude]
  end

  def create
    @student = Student.find params[:student_id]
    params[:subject_id].each do |id|
      subject = Subject.find(id)
      @student.subjects << subject
    end
    redirect_to student_schedules_path(@student)
  end

  protected
  def grid_params
    params.fetch(:schedules_grid, {}).permit!
  end
end