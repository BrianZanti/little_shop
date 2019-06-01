class Address < ApplicationRecord
  validates_presence_of :user_id, :street, :city, :state, :zip_code

  belongs_to :user
end
