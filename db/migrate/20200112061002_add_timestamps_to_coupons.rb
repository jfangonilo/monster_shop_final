class AddTimestampsToCoupons < ActiveRecord::Migration[5.1]
  def change
    add_timestamps :coupons, null: false, default: -> { 'NOW()' }
  end
end
