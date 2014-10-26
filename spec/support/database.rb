require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter:  "sqlite3",
  database:  ':memory:'
)

class SetupSchema < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :name
      t.string :email
      t.timestamps
    end

    create_table :endpoints do |t|
      t.integer :user_id
      t.string :platform
      t.string :device_token
      t.string :arn
      t.timestamps
    end
  end

  def self.down
    drop_table :users
    drop_table :endpoints
  end

  def self.suppress_migrate(direction)
    mig = new
    mig.suppress_messages do
      mig.migrate(direction)
    end
  end
end
