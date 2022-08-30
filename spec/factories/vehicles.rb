FactoryBot.define do
  factory :vehicle do
    plate { FFaker::String.from_regexp(/[A-Z]{3}-[0-9][0-9A-Z][0-9]{2}/) }
    # plate { Faker::Base.regexify(/[A-Z]{3}-[0-9][0-9A-Z][0-9]{2}/) }

    # Máscara com ou sem hífen:
    # /[A-Z]{3}-?[0-9][0-9A-Z][0-9]{2}/
  end
end
