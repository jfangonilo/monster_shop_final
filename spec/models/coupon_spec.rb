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
  end
end
