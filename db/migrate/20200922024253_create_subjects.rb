class CreateSubjects < ActiveRecord::Migration[6.0]
  def change
    create_table :subjects do |t|
      t.string :name
      t.string :time
      t.string :details

      t.timestamps
    end
  end
end
