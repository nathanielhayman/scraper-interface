class AddTaskIdToTaskMethods < ActiveRecord::Migration[6.1]
  def change
    add_column :task_methods, :task_id, :integer
  end
end
