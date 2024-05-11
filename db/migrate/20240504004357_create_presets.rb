class CreatePresets < ActiveRecord::Migration[6.1]
  def change
    create_table :presets do |t|

      t.integer :user_id, null: false
      t.string  :name
      t.string  :words
      t.integer :number,  null: false
      t.integer :target,  null: false,  default: "0"
      t.integer :option,  null: false,  default: "0"


      t.timestamps
    end
  end
end
