FactoryBot.define do
  factory :address, class: Address do
    # sequence(:email) { |n| "user_#{n}@gmail.com" }
    # password { "password" }
    # sequence(:name) { |n| "User Name #{n}" }
    sequence(:street) { |n| "Address #{n}" }
    sequence(:city) { |n| "City #{n}" }
    sequence(:state) { |n| "State #{n}" }
    sequence(:zip_code) { |n| "Zip #{n}" }
    # role { 0 }
    # active { true }
  end
end




# FactoryBot.define do
#   factory :item do
#     association :user, factory: :merchant
#     sequence(:name) { |n| "Item Name #{n}" }
#     sequence(:description) { |n| "Description #{n}" }
#     sequence(:image) { |n| "https://picsum.photos/200/300?image=#{n}" }
#     sequence(:price) { |n| ("#{n}".to_i+1)*1.5 }
#     sequence(:inventory) { |n| ("#{n}".to_i+1)*2 }
#     active { true }
#   end
#
#   factory :inactive_item, parent: :item do
#     association :user, factory: :merchant
#     sequence(:name) { |n| "Inactive Item Name #{n}" }
#     active { false }
#   end
# end
