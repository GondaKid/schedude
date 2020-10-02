class SchedulesController < ApplicationController

  def index
    @student = Student.find_by student_id: params[:student_id]
    @grid = SchedulesGrid.new(grid_params) do |scope|
      scope.joins(:students).joins(:enrollments).where("students.student_id = '#{@student.student_id}'").distinct.page(params[:page])
    end
  end

  protected

  def grid_params
    params.fetch(:schedules_grid, {}).permit!
  end

end

