class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.references :user, index: true
      t.string :name
      t.string :address
      t.string :state
      t.string :company
      t.string :money_owed

      t.timestamps null: false
    end
    add_foreign_key :results, :users
  end
end
