include Devise::TestHelpers
# gives us the sign_in(@user) method

# Will run the given code as the user passed in
def as_user(user=nil, &block)
  current_user = user || Factory.stub(:user)
  if request.present?
    sign_in(current_user)
  else
    ApplicationController.stub(:current_user => current_user)
  end
  block.call(current_user) if block.present?
  return self
end


def as_visitor(user=nil, &block)
  current_user = user || Factory.stub(:user)
  if request.present?
    sign_out(current_user)
  else
    ApplicationController.stub(:current_user => nil)
  end
  block.call(current_user) if block.present?
  return self
end

