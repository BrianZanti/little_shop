class Address < ApplicationRecord
  validates_presence_of :user_id, :street, :city, :state, :zip_code

  belongs_to :user
  has_many :orders

  def in_completed_order?
    # orders.where(status: "packaged").or(orders.where(status: "shipped")).count > 0
    orders.count > 0
  end
  #
  # def self.top_address_states_by_order_count(limit)
  #   self.joins(:orders)
  #       .where(orders: {status: :shipped})
  #       .group(:state)
  #       .select('addresses.state, count(orders.id) AS order_count')
  #       .order('order_count DESC')
  #       .limit(limit)
  # end
  #
  # def self.top_address_cities_by_order_count(limit)
  #   self.joins(:orders)
  #   .where(orders: {status: :shipped})
  #   .group(:state, :city)
  #   .select('addresses.city, addresses.state, count(orders.id) AS order_count')
  #   .order('order_count DESC')
  #   .limit(limit)
  # end
end
