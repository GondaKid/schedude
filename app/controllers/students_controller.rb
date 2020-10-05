class StudentsController < ApplicationController
  def new

  end
<<<<<<< HEAD

  def create
=======

  def create
>>>>>>> c6a971b03fcdd1c016cf0a36e6fe76b84b464c95
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
