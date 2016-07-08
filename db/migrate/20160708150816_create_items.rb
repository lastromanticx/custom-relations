class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.text :content
      t.boolean :shared
      t.integer :user_id
    end
  end
end
