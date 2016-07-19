def setup_db
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
  ActiveRecord::Base.logger = Logger.new(nil)

  ActiveRecord::Schema.define do
    create_table :delayed_jobs, force: true do |t|
      t.integer :priority, default: 0, null: false
      t.integer :attempts, default: 0, null: false
      t.text :handler,                 null: false
      t.text :last_error
      t.datetime :run_at
      t.datetime :locked_at
      t.string :locked_by
      t.string :queue
      t.timestamps null: true
    end
  end
end
