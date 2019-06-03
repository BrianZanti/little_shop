class Profile::AddressesController < ApplicationController

  def new
    @address = Address.new
  end


  def create
    new_addy = current_user.addresses.new(address_params)
    if new_addy.save
      redirect_to profile_path
    else
      render :new
    end
  end

  def destroy
    addy = Address.find(params[:id])
    addy.orders.clear
    addy.destroy
    redirect_to profile_path
  end

  private

  def address_params
    params.require(:address).permit(:nickname, :street_address, :city, :state, :zip)
  end
end
