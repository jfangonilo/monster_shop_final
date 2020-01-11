include FactoryBot::Syntax::Methods

Merchant.destroy_all
Item.destroy_all
Review.destroy_all
User.destroy_all
Order.destroy_all
ItemOrder.destroy_all

#creates 4 merchants
jomah = create(:jomah_merchant)
wren = create(:wren_merchant)
becky = create(:becky_merchant)
ray = create(:ray_merchant)

# creates one item belonging to jomah and makes 10 reviews for it
item_1 = create(:random_item, merchant: jomah)
reviews = create_list(:random_review, 10, item: item_1)

# creates 9 additional items for jomah; 6 active, 3 inactive
jomah_items = create_list(:random_item, 6, merchant: jomah)
hidden_jomah_items = create_list(:random_item, 3, merchant: jomah, active?: false)

#creates 10 items for wren; 7 active, 3 inactive
wren_items = create_list(:random_item, 7, merchant: wren)
hidden_wren_items = create_list(:random_item, 3, merchant: wren, active?: false)

#creates 10 items for becky; 7 active, 3 inactive
becky_items = create_list(:random_item, 7, merchant: becky)
hidden_becky_items = create_list(:random_item, 3, merchant: becky, active?: false)

#creates 10 items for ray; 7 active, 3 inactive
ray_items = create_list(:random_item, 7, merchant: ray)
hidden_ray_items = create_list(:random_item, 3, merchant: ray, active?: false)

#you can now log in as any of these users as defined in the factory
user = create(:regular_user)
create(:merchant_employee, merchant: jomah)
create(:merchant_admin, merchant: jomah)
create(:admin_user)

#creates 3 orders each ordering a random quantity of each item
order_1 = create(:random_order, user: user, status: 0)
Item.all.each do |item|
  create(:item_order, order: order_1, item: item, price: item.price)
end

order_2 = create(:random_order, user: user, status: 1)
Item.all.each do |item|
  create(:item_order, order: order_2, item: item, price: item.price)
end

order_3 = create(:random_order, user: user, status: 2)
Item.all.each do |item|
  create(:item_order, order: order_3, item: item, price: item.price)
end

order_4 = create(:random_order, user: user, status: 3)
Item.all.each do |item|
  create(:item_order, order: order_3, item: item, price: item.price)
end
