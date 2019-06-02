require 'rails_helper'

describe Address, type: :model do
  describe "validations" do
    # it {should validate_presence_of(:user_id)}
    # it {should validate_presence_of(:street)}
    # it {should validate_presence_of(:city)}
    # it {should validate_presence_of(:state)}
    # it {should validate_presence_of(:zip_code)}
    # ^^ No validations because user must be able to delete all their addresses
  end

  describe 'instance methods' do
    before :each do
      @user = create(:user)
      @address_1 = create(:address, user: @user)
      @address_2 = create(:address, user: @user)
      @address_3 = create(:address, user: @user)
      @address_4 = create(:address, user: @user)
      @address_5 = create(:address, user: @user)
      @item_1 = create(:item)
      @item_2 = create(:item)
      yesterday = 1.day.ago

      @order = create(:order, user: @user, created_at: yesterday, address_id: @address_1.id) #pending
      @oi_1 = create(:order_item, order: @order, item: @item_1, price: 1, quantity: 1, created_at: yesterday, updated_at: yesterday)
      @oi_2 = create(:fulfilled_order_item, order: @order, item: @item_2, price: 2, quantity: 1, created_at: yesterday, updated_at: 2.hours.ago)

      @merchant = create(:merchant)
      @i1, @i2 = create_list(:item, 2, user: @merchant)
      @o1, @o2 = create_list(:order, 2)
      @o3 = create(:packaged_order, address_id: @address_2.id)
      @o4 = create(:shipped_order, address_id: @address_3.id)
      @o5 = create(:cancelled_order, address_id: @address_4.id)
      create(:order_item, order: @o1, item: @i1, quantity: 1, price: 2)
      create(:order_item, order: @o1, item: @i2, quantity: 2, price: 2)
      create(:order_item, order: @o2, item: @i2, quantity: 4, price: 2)
      create(:order_item, order: @o3, item: @i1, quantity: 4, price: 2)
      create(:order_item, order: @o4, item: @i2, quantity: 5, price: 2)
      create(:order_item, order: @o5, item: @i1, quantity: 5, price: 2)
    end

    it '.in_completed_order?' do
      expect(@address_1.in_completed_order?).to eq(false) # order is pending
      expect(@address_2.in_completed_order?).to eq(true)  # order is packaged
      expect(@address_3.in_completed_order?).to eq(true)  # order is shipped
      expect(@address_4.in_completed_order?).to eq(false) # order is cancelled
      expect(@address_5.in_completed_order?).to eq(false) # not in an order
    end
  end


end
