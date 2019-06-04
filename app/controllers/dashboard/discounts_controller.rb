class Dashboard::DiscountsController < Dashboard::BaseController
  def new
    @discount = Discount.new
  end

  def create
    @discount = current_user.discounts.new(discount_params)
    @discount.save
    flash[:success] = "Your discount has been created!"
    redirect_to dashboard_path
  end

  private

  def discount_params
    params.require(:discount).permit(:description, :minimum_quantity, :discount_amount)
  end
end
