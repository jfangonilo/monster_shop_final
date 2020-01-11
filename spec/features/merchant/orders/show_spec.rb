require 'rails_helper'

describe "merchant order show page" do
  before :each do
    @jomah = create(:jomah_merchant)
    @ray = create(:ray_merchant)

    @user = create(:regular_user)
    @merchant_user = create(:merchant_employee, merchant: @jomah)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_user)

    @item_1 = create(:random_item, merchant: @jomah, inventory: 10)
    @item_2 = create(:random_item, merchant: @jomah, inventory: 5)
    @item_3 = create(:random_item, merchant: @ray, inventory: 10)

    @order = create(:random_order, user: @user)
    @item_order_1 = create(:item_order, order: @order, item: @item_1, price: @item_1.price, quantity: 5)
    @item_order_2 = create(:item_order, order: @order, item: @item_2, price: @item_2.price, quantity: 6)
    @item_order_3 = create(:item_order, order: @order, item: @item_3, price: @item_3.price, quantity: 5)
  end

  it 'shows the customers name and address' do
    visit "/merchant/orders/#{@order.id}"

    within ".shipping-address" do
      expect(page).to have_content @order.name
      expect(page).to have_content @order.address
      expect(page).to have_content @order.city
      expect(page).to have_content @order.state
      expect(page).to have_content @order.zip
    end
  end

  it 'only shows my items' do
    visit "/merchant/orders/#{@order.id}"

    within "#item-#{@item_1.id}" do
      expect(page).to have_link @item_1.name
      expect(page).to have_css "img[src*='#{@item_1.image}']"
      expect(page).to have_content number_to_currency(@item_1.price/100.to_f)
      expect(page).to have_content @item_order_1.quantity
    end

    within "#item-#{@item_2.id}" do
      expect(page).to have_link @item_2.name
      expect(page).to have_css "img[src*='#{@item_2.image}']"
      expect(page).to have_content number_to_currency(@item_2.price/100.to_f)
      expect(page).to have_content @item_order_2.quantity
    end

    expect(page).not_to have_link @item_3.name
  end

  it 'allows me to fullfil individual items' do
    visit "/merchant/orders/#{@order.id}"
    within "#item-#{@item_1.id}" do
      click_button "Fulfill"
    end
    @item_order_1.reload
    expect(@item_order_1.status).to eq "fulfilled"
    @item_1.reload
    expect(@item_1.inventory).to eq 5

    expect(current_path).to eq("/merchant/orders/#{@order.id}")
    within "#item-#{@item_1.id}" do
      expect(page).not_to have_button "Fulfill"
      expect(page).to have_content "Fulfilled"
    end
  end

  it 'doesnt alow me to fulfill an item if inventory insufficient' do
    visit "/merchant/orders/#{@order.id}"
    within "#item-#{@item_2.id}" do
      expect(page).to have_content "Insufficient Inventory"
    end
  end

end