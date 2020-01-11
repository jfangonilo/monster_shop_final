FactoryBot.define do
  factory :random_review, class: Review do
    title         {Faker::Movies::BackToTheFuture.quote}
    content       {Faker::TvShows::Seinfeld.quote}
    rating        {rand(1..5)}
    association   :item, factory: :random_item
  end
end