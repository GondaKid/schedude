class AddNotNullToStudent < ActiveRecord::Migration[6.0]
  def change
    change_column :students, :student_id, :string, :null => false, :limit => 10
  end
end
