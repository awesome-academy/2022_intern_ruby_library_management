class ChangeDescriptToBooks < ActiveRecord::Migration[6.1]
  def change
    change_table :books do |t|
      t.change :description, :longtext
    end
  end
end
