class CreateEnrollments < ActiveRecord::Migration[6.0]
  def change
    create_table :enrollments, id:false do |t|
      t.belongs_to :subject, index: true
      t.belongs_to :student, index:true

      t.timestamps
    end
  end
end
