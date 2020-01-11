class AddImageToItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :image
    add_column :items, :image, :string, default: "https://amp.businessinsider.com/images/5cdee90d021b4c15350f0c03-1136-852.jpg"
  end
end
