FactoryBot.define do
  factory :item_order, class: ItemOrder do
    price       {rand(1..100)}
    quantity    {rand(1..100)}
    association :item, factory: :random_item
    association :order, factory: :random_order
  end
end