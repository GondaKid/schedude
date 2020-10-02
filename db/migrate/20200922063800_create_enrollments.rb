# auto-generated migrate file when generate model enrollment
class CreateEnrollments < ActiveRecord::Migration[6.0]
  def change
    add_column :enrollments, :created_at, :datetime, null: false
    add_column :enrollments, :updated_at, :datetime, null: false
  end
end
    