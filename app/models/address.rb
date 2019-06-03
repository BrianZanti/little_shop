class Address < ApplicationRecord
  belongs_to :user
  has_many :orders

  validates_presence_of :street_address, :state, :city, :zip, :nickname

  def is_part_of_completed_order?
    orders.any? { |order| order[:status] == 'packaged' || order[:status] == 'shipped' }
  end
end
