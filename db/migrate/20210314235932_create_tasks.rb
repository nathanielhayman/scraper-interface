class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.string :short
      t.datetime :time
      t.string :regularity
      t.string :status, :default => "Running"

      t.timestamps
    end
  end
end
