class CreateTaskMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :task_methods do |t|
      t.string :action_type
      t.string :action
      t.integer :delay
      t.string :modifier
      t.string :mod_val

      t.timestamps
    end
  end
end
