class UsersController < ApplicationController
  before_action :require_reguser, except: [:new, :create]

  def new
    @user = User.new
    @address = @user.addresses.new
  end

  def show
    @user = current_user
    @addresses = @user.addresses
  end

  def edit
    @user = current_user
  end

  def create
    @user = User.new(user_params)
    @address = @user.addresses.new(address_params)
    if @user.save && @address.save
      session[:user_id] = @user.id
      flash[:success] = "Registration Successful! You are now logged in."
      redirect_to profile_path
    else
      flash.now[:danger] = @user.errors.full_messages
      @user.update(email: "", password: "")
      render :new
    end
  end

  def update
    @user = current_user
    @user.update(user_update_params)

    if @user.save && user_update_addresses
      flash[:success] = "Your profile has been updated"
      redirect_to profile_path
    else
      flash.now[:danger] = @user.errors.full_messages
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def address_params
    params[:user][:addresses_attributes].require("0").permit(:street_address, :city, :state, :zip)
  end

  def user_update_addresses
    did_update_addresses = true

    updated_addresses = params[:user][:addresses_attributes].values
    updated_addresses.each do |address|
      addy_to_update = @user.addresses.find(address.delete(:id))
      did_update_addresses = false unless addy_to_update.update(address)
    end

    did_update_addresses
  end

  def user_update_params
    uup = user_params
    uup.delete(:password) if uup[:password].empty?
    uup.delete(:password_confirmation) if uup[:password_confirmation].empty?
    uup
  end
end
