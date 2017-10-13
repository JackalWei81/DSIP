class CreateOriDataTables < ActiveRecord::Migration[5.0]
  def change
    create_table :ori_data_tables do |t|
      t.string :province, null: false
      t.string :city
      t.string :ip_start, null: false
      t.string :ip_end, null: false
      t.text :description
      t.text :remark

      t.timestamps
    end
  end
end
