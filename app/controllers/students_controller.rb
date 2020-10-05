class StudentsController < ApplicationController
  def new

  end

  def create
    # @schedule = params[:student][:schedule]
    render plain: params[:student].inspect
    # @student = Student.new student_param

    # if @student.save
    #   redirect_to @student
    # else
    #   render 'new'
    # end

  end

  def show
    # @student = Student.find params[:id]
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
