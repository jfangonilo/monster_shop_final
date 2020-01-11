class Admin::DashboardController < Admin::BaseController
  def index
    @orders = Order.sort_by_status
  end
end
