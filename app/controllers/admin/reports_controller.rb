class Admin::ReportsController < ApplicationController
  before_filter :authenticate_admin!

  def index
    @users         = current_account ? current_account.users.uniq : User.uniq.includes(:memberships, [:memberships => :account])
    @top_user_hash = current_account.roles.group(:user_id).count(:user_id).sort_by {|id, count| count}.reverse.first(20)
  end

end
