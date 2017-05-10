class UsersController < ApplicationController
  def index
    @users = User.fetch
  end

  def me
    @user = User.via_mccracken(current_user) do |u|
      u.include(:apikeys, :identities).find(current_user['uid'])
    end
    @identities = @user.identities
    @apikeys = @user.apikeys
  end

  # POST /users/add_api_key
  def add_api_key
    @api_key = APIKey.via_mccracken(current_user) { |a| a.new }
    @api_key.save
  end

  # POST /users/remove_api_key
  def remove_api_key
    @api_key = APIKey.via_mccracken(current_user) { |a| a.find(params[:id]) }
    @api_key.destroy
    redirect_to me_path
  end

  def reset_password
    user = User.via_mccracken(current_user) {|u| u.find(current_user['uid']) }
    if params[:reset][:password1] == params[:reset][:password2]
      user.password = params[:reset][:password1]
      user.save
      flash[:success] = 'Password Reset'
    else
      flash[:alert] = 'Password Reset Failed! Passwords must match.'
    end
    redirect_to me_path
  end
end
