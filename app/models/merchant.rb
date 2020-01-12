class Merchant <ApplicationRecord
  validates_presence_of :name,
                        :address,
                        :city,
                        :state,
                        :zip, numericality: { only_integer: true, message: "must be a number" }

  has_many :items, dependent: :destroy
  has_many :item_orders, through: :items
  has_many :orders, through: :item_orders
  has_many :users
  has_many :coupons

  def no_orders?
    item_orders.empty?
  end

  def item_count
    items.count
  end

  def average_item_price
    items.average(:price)
  end

  def distinct_cities
    item_orders.distinct.joins(:order).pluck(:city)
  end

  def pending_orders
    orders.distinct.where(status: "pending")
  end

  def item_orders_from(order)
    item_orders.where(order: order)
  end
end
