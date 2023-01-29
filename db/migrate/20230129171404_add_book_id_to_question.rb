class AddBookIdToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :book_id, :bigint
  end
end
