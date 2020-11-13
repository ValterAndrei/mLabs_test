FactoryBot.define do
  factory :reservation do
    checkin  { Time.new }
    checkout { Time.new }
    paid     { false }
    left     { false }
  end
end
