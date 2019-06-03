require 'rails_helper'

RSpec.describe Address, type: :model do
  describe 'validations' do
    it { should validate_presence_of :street_address}
    it { should validate_presence_of :state}
    it { should validate_presence_of :city}
    it { should validate_presence_of :zip}
    it { should validate_presence_of :nickname}
  end

  describe 'relationships' do
    it { should have_many :orders}
    it { should belong_to :user}
  end


  describe 'instance methods' do

    before :each do
      @address = create(:address)
      order = create(:order, address: @address, status: :pending)

      @address_shipped_order = create(:address)
      order_complete = create(:order, status: :shipped, address: @address_shipped_order)

      @address_packaged_order = create(:address)
      order = create(:order,status: :packaged, address: @address_packaged_order)
    end
    it { expect(@address.is_part_of_completed_order?).to be_falsy }
    it { expect(@address_shipped_order.is_part_of_completed_order?).to be_truthy }
    it { expect(@address_packaged_order.is_part_of_completed_order?).to be_truthy }
  end
end
