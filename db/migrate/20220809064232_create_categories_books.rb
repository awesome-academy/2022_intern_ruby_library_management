class CreateCategoriesBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :categories_books do |t|
      t.references :book
      t.references :category_book
    end
  end
end
