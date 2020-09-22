class CreateStudents < ActiveRecord::Migration[6.0]
  def change
    create_table :students do |t|
      t.string :student_id
      t.references :school, null: false, foreign_key: true

      t.timestamps
    end
  end
end
