class Discount < ApplicationRecord

  belongs_to :user #, foreign_key: 'merchant_id'  #Will this 'merchant_id' work?
  validates_presence_of :discount_amount
  validates_presence_of :minimum_quantity
  validates_presence_of :description


end
