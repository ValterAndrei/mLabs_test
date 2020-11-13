FactoryBot.define do
  factory :vehicle do
    plate { FFaker::String.from_regexp(/[a-zA-Z]{3}-\d{4}/) }
  end
end
