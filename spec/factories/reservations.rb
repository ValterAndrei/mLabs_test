FactoryBot.define do
  factory :reservation do
    vehicle
    checkin  { Time.new }
    checkout { nil }
    paid     { false }
    left     { false }
  end
end
