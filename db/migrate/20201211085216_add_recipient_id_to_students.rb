class AddRecipientIdToStudents < ActiveRecord::Migration[6.0]
  def change
    add_column :students, :recipient_id, :string
  end
end
