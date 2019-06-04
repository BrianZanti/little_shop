class Dashboard::DiscountsController < Dashboard::BaseController
  def new
    @discount = Discount.new
  end

  def create


    redirect_to dashboard_path
  end
end
