FactoryBot.define do
  factory :address, class: Address do
    # sequence(:email) { |n| "user_#{n}@gmail.com" }
    # password { "password" }
    # sequence(:name) { |n| "User Name #{n}" }
    sequence(:street) { |n| "Address #{n}" }
    sequence(:city) { |n| "City #{n}" }
    sequence(:state) { |n| "State #{n}" }
    sequence(:zip) { |n| "Zip #{n}" }
    # role { 0 }
    # active { true }
  end
end
