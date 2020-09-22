class CreateJoinTableEnrollment < ActiveRecord::Migration[6.0]
  def change
    create_join_table :Students, :Subjects do |t|
      # t.index [:student_id, :subject_id]
      # t.index [:subject_id, :student_id]
    end
  end
end
