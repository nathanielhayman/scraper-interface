class AddStarredToTask < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :starred, :boolean
  end
end
