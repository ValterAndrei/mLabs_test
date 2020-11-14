FactoryBot.define do
  factory :reservation do
    vehicle
    checkin  { Time.new }
    checkout { Time.new }
    paid     { false }
    left     { false }
  end
end
