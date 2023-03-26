class AddFileContentToBook < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :file_content, :jsonb
    add_column :books, :content_type, :integer
  end
end
