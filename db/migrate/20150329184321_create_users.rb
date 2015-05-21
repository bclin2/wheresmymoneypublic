class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :provider, :uid, :name, :email, :googlecontactid
      t.boolean :queried_money_databases, :have_google_photo, default: false

      t.timestamps null: false
    end
  end
end
