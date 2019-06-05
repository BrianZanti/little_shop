require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe 'validations' do
    it { should validate_presence_of :discount_amount }
    it { should validate_numericality_of(:discount_amount).is_greater_than(0) }

    it { should validate_presence_of :minimum_quantity }
    it { should validate_numericality_of(:minimum_quantity).only_integer }
    it { should validate_numericality_of(:minimum_quantity).is_greater_than_or_equal_to(0) }

    it { should validate_presence_of :description}
  end

  describe 'relationships' do
    it { should belong_to :user }
  end

  describe 'creation exists' do
    it 'can create a discount' do
      merchant = create(:user, role: 1)
      discount = create(:discount, user: merchant)

      expect(discount.description).to eq("Discount description 1")
      expect(discount.minimum_quantity).to eq(4)
      expect(discount.discount_amount).to eq(3)
      expect(discount.user).to eq(merchant)
    end
  end

  describe 'instance methods' do
    before :each do
      @merchant_1 = create(:merchant)
      @merchant_2 = create(:merchant)
      @address_1 = create(:address, user: @merchant_1)
      @address_2 = create(:address, user: @merchant_2)

      @user_1 = create(:user)
      @user_2 = create(:user)
      @address_3 = create(:address, user: @user_1)
      @address_4 = create(:address, user: @user_2)

      @discount_1 = create(:discount, user: @merchant_1, minimum_quantity: 2, discount_amount: 10)
      @discount_2 = create(:discount, user: @merchant_1, minimum_quantity: 4, discount_amount: 20)
      @discount_3 = create(:discount, user: @merchant_1, minimum_quantity: 6, discount_amount: 30)

      @discount_1 = create(:discount, user: @merchant_2, minimum_quantity: 2, discount_amount: 10)
      @discount_2 = create(:discount, user: @merchant_2, minimum_quantity: 4, discount_amount: 20)
      @discount_3 = create(:discount, user: @merchant_2, minimum_quantity: 6, discount_amount: 30)

      @order_1 = create(:order, user: @user_1)
      @order_2 = create(:order, user: @user_1)
      @order_3 = create(:order, user: @user_2)


      @item_1 = create(:item, user: @merchant_1, inventory: 100)
      @item_2 = create(:item, user: @merchant_1, inventory: 100)
      @item_3 = create(:item, user: @merchant_2, inventory: 100)
      @item_4 = create(:item, user: @merchant_2, inventory: 100)

      # @order_item_1 = create(:order_item, order: @order_1, item: @item_1, quantity: 1, price: 2)
      # @order_item_2 = create(:order_item, order: @order_1, item: @item_2, quantity: 1, price: 3)
      #
      # @order_item_3 = create(:order_item, order: @order_1, item: @item_3, quantity: 2, price: 4)
      # @order_item_4 = create(:order_item, order: @order_2, item: @item_1, quantity: 1, price: 2)
      #
      # @order_item_5 = create(:order_item, order: @order_2, item: @item_2, quantity: 3, price: 3)
      # @order_item_6 = create(:order_item, order: @order_2, item: @item_3, quantity: 1, price: 4)
      #
      # @order_item_7 = create(:order_item, order: @order_2, item: @item_1, quantity: 1, price: 2)
      # @order_item_8 = create(:order_item, order: @order_2, item: @item_2, quantity: 1, price: 3)
      #
      # @order_item_9 = create(:order_item, order: @order_2, item: @item_3, quantity: 1, price: 4)


    end

    it '.find_discount(merchant) finds no discount when no item exceeds the minimum quantity but total order items quantity does' do
      @order_item_1 = create(:order_item, order: @order_1, item: @item_1, quantity: 1, price: 2)
      @order_item_2 = create(:order_item, order: @order_1, item: @item_2, quantity: 1, price: 3)
      @order_item_2 = create(:order_item, order: @order_1, item: @item_2, quantity: 1, price: 3)

      expect(@order_1.items.length).to eq(3)
      expect(@order_1.find_discount(@merchant_1)).to eq(nil)

    end
  end
end
