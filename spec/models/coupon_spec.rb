require 'rails_helper'

RSpec.describe Coupon do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_uniqueness_of :name }
    it { should validate_presence_of :code }
    it { should validate_uniqueness_of :code }
    it { should validate_presence_of :percent_off }
    it { should validate_numericality_of(:percent_off).is_less_than(1) }
    it { should validate_numericality_of(:percent_off).is_greater_than(0) }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many :orders }
  end

  describe 'instance methods' do
    before :each do
      @merchant = create(:jomah_merchant)
      @coupon_1 = create(:coupon_1, merchant: @merchant)
      @coupon_2 = create(:coupon_2, merchant: @merchant)
      @order = create(:random_order, coupon: @coupon_2)
    end

    it 'no_orders?' do
      expect(@coupon_1.no_orders?).to be true
      expect(@coupon_2.no_orders?).to be false
    end
  end
end
