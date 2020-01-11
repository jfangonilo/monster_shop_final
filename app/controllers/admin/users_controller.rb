class Admin::UsersController < Admin::BaseController
  def index
    @users = User.unscoped.all
  end

  def show
    @display_user = User.find(params[:id])
  end

  def edit
    @display_user = User.find(params[:id])
  end

  def update
    @display_user = User.find(params[:id])
    if params[:password]
      password_update
    elsif @display_user.update(user_params)
      flash[:success] = "Your profile has been updated."
      redirect_to admin_dash_user_path(@display_user)
    else
      generate_error(@display_user)
      redirect_to admin_dash_user_path(@display_user)
    end
  end

  def update_role
    @user = User.find(params[:user_id])
    @user.update(user_role_params)
    flash[:success] = "The user role has been updated to #{@user.role}."
    redirect_to admin_dash_users_path
  end

  def toggle_active
    user = User.find(params[:user_id])
    user.toggle!(:active)
    redirect_to admin_dash_users_path
    if user.active?
      flash[:success] = "#{user.name} has been enabled."
    else
      flash[:success] = "#{user.name} has been disabled."
    end
  end

  def edit_password
    @display_user = User.find(params[:user_id])
  end

private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end

  def user_role_params
    params.require(:user).permit(:role)
  end

  def password_update
    if params[:password] == params[:password_confirmation]
      @display_user.update(user_params)
      flash[:success] = "Password has been updated."
      redirect_to admin_dash_user_path(@display_user)
    else
      flash[:error] = "Passwords entered do not match."
      redirect_to admin_dash_user_edit_password_path(@display_user)
    end
  end
end
