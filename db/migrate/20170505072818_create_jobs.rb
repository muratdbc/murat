class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|
      t.date :job_date
      t.text :notes
      t.time :job_time
      t.boolean :back_to_back
      t.text :access_code
      t.text :wifi_name
      t.text :wifi_password
      t.text :external_key
      t.text :external_source
      t.boolean :is_deleted,  default: false
      t.boolean :is_active,  default: false
      t.text :address_1
      t.text :city
      t.text :state
      t.timestamps
    end
  end
end
