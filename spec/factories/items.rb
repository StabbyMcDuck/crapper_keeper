FactoryGirl.define do
  factory :item do
    container
    name { Faker::Commerce.product_name }
    notification_style { generate :item_notification_style }
    count { generate :item_count }

    factory :full_item do
      description { Faker::Hipster.paragraph }
      last_used_at { 1.week.ago }
      notification_frequencies { generate :item_notification_frequencies }
    end

  end

  sequence(:item_count){ |n| n+1 }
  sequence(:item_notification_frequencies){ |n|
    count = n % Item::NOTIFICATION_FREQUENCIES.length + 1
    Item::NOTIFICATION_FREQUENCIES.sample(count)
  }
  sequence(:item_notification_style, Item::NOTIFICATION_STYLES.cycle)

end