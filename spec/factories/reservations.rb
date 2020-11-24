FactoryBot.define do
  factory :reservation do
    vehicle
    checkin  { Time.zone.now }
    checkout { nil }
    paid     { false }
    left     { false }
  end
end
