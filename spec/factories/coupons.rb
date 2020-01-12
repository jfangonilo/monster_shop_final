FactoryBot.define do
  factory :coupon_1, class: Coupon do
    name        { "50OFF" }
    code        { "50OFF" }
    percent_off { 0.50 }
    association :merchant, factory: :jomah_merchant
  end

  factory :coupon_2, class: Coupon do
    name        { "25OFF" }
    code        { "25OFF" }
    percent_off { 0.25 }
    association :merchant, factory: :jomah_merchant
  end
end