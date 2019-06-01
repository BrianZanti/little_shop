class Profile::AddressesController < ApplicationController

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)
    @address.user_id = current_user.id
    # if @address.save
      @address.save
      flash[:success] = "You added a new address."
      redirect_to profile_path
    # else
    #   flash[:error] = "That nickname was already taken."
    #   redirect_to undetermined_path
    # end
  end

  def edit
    @address = Address.find(params[:id])
  end

  def destroy
    @address = Address.find(params[:id])
    @address.destroy
    redirect_to profile_path
  end


  private

    def address_params
      params.require(:address).permit(:nickname, :street, :city, :state, :zip_code)
    end
end
