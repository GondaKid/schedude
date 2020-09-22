class StudentsController < ApplicationController
  def new
  end
  
  def create 
    @student = Student.new(student_params)

    @student.save
    redirect_to @student_path
  end

  private

  def student_params
    params.require(:student).permit(:name, :school)
  end

end
