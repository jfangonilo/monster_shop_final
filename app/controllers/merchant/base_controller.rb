class Merchant::BaseController < ApplicationController
  before_action :require_merchant, :exclude_admin
end