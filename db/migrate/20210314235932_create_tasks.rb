class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title
      t.string :description
      t.string :short
      t.datetime :time
      t.string :regularity
      t.boolean :starred, default: false
      t.string :status, default: "Running"
      t.json :variables, default: [], array: true
      t.json :data, default: [], array: true
      t.json :logs, default: [], array: true

      t.timestamps
    end
  end
end
