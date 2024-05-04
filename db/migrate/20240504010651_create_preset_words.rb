class CreatePresetWords < ActiveRecord::Migration[6.1]
  def change
    create_table :preset_words do |t|

      t.integer :preset_id, null: false
      t.integer :number,    null: false
      t.string  :body

      t.timestamps
    end
  end
end
