class RemoveSchoolnameFromStudent < ActiveRecord::Migration[6.0]
  def change
    remove_column :students, :school_name
  end
end
