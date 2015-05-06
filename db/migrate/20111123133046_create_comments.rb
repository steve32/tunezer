class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :username
      t.text :content
      t.references :concert
      t.references :user
      
      t.timestamps
    end
  end
end
