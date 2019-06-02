class Admin::OrdersController < Admin::BaseController
  def show
    @merchant = User.find(params[:merchant_id])
    @order = Order.find(params[:id])
    @user = @order.user
    @order_items = @order.order_items_for_merchant(@merchant.id)

    render :'/dashboard/orders/show'
  end

  def ship
    # require 'pry'; binding.pry # look for params[:interest] or [:shipping_address]
    order = Order.find(params[:order_id])
    order.status = :shipped
    order.save
    redirect_to admin_dashboard_path
  end
end
