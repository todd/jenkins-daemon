class CreatePullRequests < ActiveRecord::Migration
  def change
    create_table :pull_requests do |t|
      t.string :ref
      t.string :sha
      t.text :data

      t.timestamps
    end
  end
end
