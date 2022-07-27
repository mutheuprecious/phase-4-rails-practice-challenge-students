class StudentsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found_exception
rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity_exception
  def index
    render json: Student.all
  end

  def show
    render json: find_student
  end

  def create
    new_student = Student.create!(student_params)
    render json: new_student, status: :created
  end

  def update
    updated = find_student.update(student_params)
    if updated
      render json: find_student
    else
      render json: {error: "Invalid parameters given" }, status: :forbidden
    end
  end

  def destroy
    find_student.destroy
    render json: {}, status: :ok
  end
  
  private

  def student_params
    params.permit(:name, :major, :age, :instructor_id)
  end

  def find_student
    Student.find(params[:id])
  end

  def record_not_found_exception
    render json: { error: "Student data not found" }, status: :not_found
  end

  def unprocessable_entity_exception(exception)
    render json: { errors: exception.errors.full_messages}, status: :unprocessable_entity
  end
end
