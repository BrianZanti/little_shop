class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|

      t.string :name
      t.string :password_digest
      t.string :email, unique: true
      t.integer :role, default: 0
      t.boolean :active, default: true

      t.timestamps
    end

  end
end
