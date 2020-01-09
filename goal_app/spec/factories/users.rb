FactoryBot.define do
    factory :user do
        username {Faker::Internet.email}
        password {'hunter2'}
    end
end