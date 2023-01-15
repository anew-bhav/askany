class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.text :query
      t.text :answer
      t.text :context
      t.integer :ask_count, default: 1

      t.timestamps
    end
  end
end
