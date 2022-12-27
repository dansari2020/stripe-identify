class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.json :body

      t.timestamps
    end
  end
end
