require 'rails_helper'

RSpec.describe 'Cart show' do
  describe 'When I have added items to my cart' do
    describe 'and visit my cart path' do
      before(:each) do
        @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
        @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
        @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
        visit "/items/#{@paper.id}"
        click_on "Add To Cart"
        visit "/items/#{@tire.id}"
        click_on "Add To Cart"
        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"
        @items_in_cart = [@paper,@tire,@pencil]
      end

      it 'I can empty my cart by clicking a link' do
        visit '/cart'
        expect(page).to have_link("Empty Cart")
        click_on "Empty Cart"
        expect(current_path).to eq("/cart")
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it 'I see all items Ive added to my cart' do
        visit '/cart'

        @items_in_cart.each do |item|
          within "#cart-item-#{item.id}" do
            expect(page).to have_link(item.name)
            expect(page).to have_css("img[src*='#{item.image}']")
            expect(page).to have_link("#{item.merchant.name}")
            expect(page).to have_content(number_to_currency(item.price/100.to_f))
            expect(page).to have_content("1")
            expect(page).to have_content(number_to_currency(item.price/100.to_f))
          end
        end
        expect(page).to have_content("Total: $1.22")

        visit "/items/#{@pencil.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#cart-item-#{@pencil.id}" do
          expect(page).to have_content("2")
          expect(page).to have_content("$0.04")
        end

        expect(page).to have_content("Total: $1.24")
      end
    end
  end
  describe "When I haven't added anything to my cart" do
    describe "and visit my cart show page" do
      it "I see a message saying my cart is empty" do
        visit '/cart'
        expect(page).to_not have_css(".cart-items")
        expect(page).to have_content("Cart is currently empty")
      end

      it "I do NOT see the link to empty my cart" do
        visit '/cart'
        expect(page).to_not have_link("Empty Cart")
      end

      it "I can see a button/link to add to the count of items I want to purchase" do
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        visit "/items/#{tire.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#item-#{tire.id}" do
          expect(page).to have_button("Add Item")
          expect(page).to have_content("1")

          click_on "Add Item"
          expect(page).to have_content("2")
        end
          expect(current_path).to eq("/cart")
      end

      it "I cannot add to the count beyond the item's inventory size" do
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        visit "/items/#{tire.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#item-#{tire.id}" do
          11.times { click_on "Add Item" }
          expect(page).to have_content("12")

          click_on "Add Item"
          expect(page).to have_content("12")
        end
          expect(current_path).to eq("/cart")
      end

      it "I can see a button/link to subtract the count of items I want to purchase" do
        meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

        tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
        visit "/items/#{tire.id}"
        click_on "Add To Cart"

        visit '/cart'

        within "#item-#{tire.id}" do
          expect(page).to have_button("Subtract Item")
          expect(page).to have_content("1")

          click_on "Add Item"
          expect(page).to have_content("2")
          click_on "Subtract Item"
          expect(page).to have_content("1")
        end
          expect(current_path).to eq("/cart")
          click_on "Subtract Item"
          expect(page).not_to have_content("#{tire.name}")
          expect(page).not_to have_content(number_to_currency(tire.price/100.to_f))
          expect(page).not_to have_button("Add Item")
          expect(page).not_to have_button("Subtract Item")
          expect(current_path).to eq("/cart")
          expect(page).to have_content("Cart is currently empty")
      end
    end
  end
end
