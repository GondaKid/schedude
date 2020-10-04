class CreateSubjects < ActiveRecord::Migration[6.0]
  def change
    create_table :subjects do |t|
      t.string :name
      t.string :code
      t.string :time

      t.timestamps
    end
  end
end
