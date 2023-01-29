class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.text :prompt
      t.jsonb :file_data
      t.jsonb :embeddings

      t.timestamps
    end
  end
end
