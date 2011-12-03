class MembersController < ApplicationController
  before_filter :authenticate_member!
  before_filter :find_member

  def index
     @members = Member.all
   end

   def show
     @member = Member.find(params[:id])
   end

   protected
   def find_member

     if params[:id]
       @member = Member.find(params[:id])
       unless current_member == @member
          redirect_to current_member, :alert => "You cannot perform this action!"
        end
     end
  end
end
