FactoryBot.define do
  factory :jomah_merchant, class: Merchant do
    name      {"Jomah's Shop of Horrors"}
    address   {"6303 W Exposition Ave"}
    city      {"Lakewood"}
    state     {"CO"}
    zip       {80226}
  end

  factory :wren_merchant, class: Merchant do
    name      {"Atlas of Aliens"}
    address   {"11 Tunnel Dr"}
    city      {"New York"}
    state     {"NY"}
    zip       {12321}
  end

  factory :becky_merchant, class: Merchant do
    name      {"Winnie's Wolly Works"}
    address   {"17 Werewolf Ln"}
    city      {"Scaryville"}
    state     {"ID"}
    zip       {66556}
  end

  factory :ray_merchant, class: Merchant do
    name      {"Vintage Vampire"}
    address   {"10 Bloodrose Ln"}
    city      {"Los Angeles"}
    state     {"CA"}
    zip       {90210}
  end
end