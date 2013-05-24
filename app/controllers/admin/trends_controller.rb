class Admin::TrendsController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @users = current_account ? current_account.users.uniq : User.uniq.includes(:memberships, [:memberships => :account])
    @top_users = current_account.users.where(:admin => false).find(:all, :include => :roles).sort_by { |u| u.roles.size }.reverse.first(20).uniq
  end

end