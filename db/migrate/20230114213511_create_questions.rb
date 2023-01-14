class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.text :prompt
      t.text :answer
      t.text :context
      t.integer :ask_count

      t.timestamps
    end
  end
end
