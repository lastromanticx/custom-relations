class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :name
      t.string :content
      t.boolean :shared
      t.integer :item_id
    end
  end
end
