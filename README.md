# Monster Shop Extensions

Monster Shop Extensions is the final solo project for Turing's Module 2 Back End Engineering program, built on a previous brownfield group project named Monster Shop.

Monster Shop is a fictional ecommerce website that allows you to browse through merchants and their items, add goods to your cart, and check out.

As a user, you have the ability to peruse the website without logging in, and add items to your cart. When you are ready to check out, you are required to register or log in to your profile. Once you have a profile, you have the ability to check out, change your password, change your personal information, view orders, or continue shopping.

As a merchant, you have two different roles, merchant employee or merchant admin. A merchant employee can fulfill orders, create items, delete items, and view orders placed for that merchant. As a merchant admin, you have the same functionality, and you also have the ability to edit the merchant data.

As an administrator, you have admin only views of merchant pages and user pages, except password edit. An admin can also fulfill and ship orders on behalf of a merchant. An admin has the ability to activate and deactivate merchants and users, as well as change the role of a user.

## Coupon Codes

#### General Goals

Merchant users can generate coupon codes within the system.

#### Completion Criteria

1. Merchant users have a link on their dashboard to manage their coupons.
1. Merchant users have full CRUD functionality over their coupons with exceptions mentioned below:
   - merchant users cannot delete a coupon that has been used in an order
   - Note: Coupons cannot be for greater than 100% off.

1. A coupon will have a coupon name, a coupon code, and a percent-off value. The name and coupon code must be unique in the whole database. 
1. Users need a way to add a coupon code when checking out. Only one coupon may be used per order.
1. A coupon code from a merchant only applies to items sold by that merchant.


#### Implementation Guidelines

1. If a user adds a coupon code, they can continue shopping. The coupon code is still remembered when returning to the cart page. (This information should not be stored in the database until after checkout. )
1. The cart show page should calculate subtotals and the grand total as usual, but also show a "discounted total".
1. Users can enter different coupon codes until they finish checking out, then the last code entered before clicking checkout is final.
1. Order show pages should display which coupon was used, as well as the discounted price.

#### Extensions
1. Coupons can be used by multiple users, but may only be used one time per user.
1. Merchant users can enable/disable coupon codes
1. Merchant users can have a maximum of 5 coupons in the system

#### Mod 2 Learning Goals reflected:

- Database relationships and migrations
- ActiveRecord
- Software Testing
- HTML/CSS layout and styling

---

### [Heroku Link](https://final-monstershop-jf.herokuapp.com/)

### [Jomah's GitHub Profile](https://github.com/jfangonilo)

### Logins
|| **Email** | **Password** |
| --- | --- | --- |
| Regular User | `imbatman@bat.com` | `robinsucks` |
| Merchant Employee User | `hailhydra@redskullmaiil.com` | `america!1` |
| Merchant Admin User | `abird@dmail.com` | `krypto2` |
| Admin User | `fastestmanalive@yaboo.com` | `imfast1` |

### Schema Design

![schema](https://user-images.githubusercontent.com/53122061/72416804-ba33b780-3734-11ea-9c38-992b0e57ccb8.png)

### Code Snippets

#### Model Methods
Methods for the item model that return the discounted price of an item if coupon's `merchant_id` matches the item's `merchant_id` else the original price if the coupon isn't applicable to the item
```ruby
# item.rb
def coupon_applicable?(coupon)
  (coupon && coupon.merchant_id == merchant_id) ? true : false
end

def discount_if_applicable(coupon)
  coupon_applicable?(coupon) ? price*(1-coupon.percent_off) : price
end
```

#### Controller Methods
The helper method `create_order` for the Orders Controller that uses the above model methods to avoid extra conditionals and keep the controller DRY. 
``` ruby
# orders_controller.rb
class User::OrdersController < User::BaseController

  def new
  end

  def show
    @order = current_user.orders.find(params[:id])
  end

  def create
    order = current_user.orders.create(order_params)
    if order.save
      create_order(order)
      flash[:notice] = "Order Placed"
      redirect_to profile_orders_path
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end

  def index
    @orders = current_user.orders
  end

  def cancel
    @order = current_user.orders.find(params[:id])
    @order.cancel
    flash[:notice] = "Order Cancelled"
    redirect_to profile_path
  end

private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end

  def create_order(order)
    order.update(coupon: coupon)
    cart.items.each do |item,quantity|
      order.item_orders.create({
        item: item,
        quantity: quantity,
        price: item.discount_if_applicable(coupon)
      })
    end
    session.delete(:cart)
    session.delete(:coupon)
  end
end
```
