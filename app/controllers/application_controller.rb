require 'digest/md5'

class ApplicationController < ActionController::Base
#   before_filter :create_first_admin
   before_filter :authorize, :except => :login



  protect_from_forgery

  private

    def current_cart
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
    
    
  REALM = "SuperSecret" 
  USERS = { "test1" => "1234", #plain text password
            "test2" => Digest::MD5.hexdigest(["test2", REALM, "1234"].join(":")) }  #ha1 digest password
    
    protected
		def authorize_digest
			authenticate_or_request_with_http_digest(REALM) do |username|
				USERS[username]
			end
		end  

    
      # def authorize
#         unless User.find_by_id(session[:user_id])
#           redirect_to login_url, notice: "Please login in"
#         end
#       end
      
#     def create_first_admin
#         flash[:alert] = %q{There are currently no users in the database.
#         Please create one administrator user} if User.count == 0
# 
#         ignore1 = (controller_name+action_name != "usersnew")
#         ignore2 = !request.post? || controller_name != "users" 
# 
#         if User.count == 0 && ignore1 && ignore2
#             session[:user_id] = nil;
#             redirect_to :controller => :users, :action => :new
#         end 
#     end

def authorize
    if  User.count == 0  
				flash[:alert] = "Please create first admin" 
				redirect_to new_user_path
  else
			unless User.find_by_id(session[:user_id])
						flash[:notice] = "Please log in" 
						redirect_to login_url, notice: "Please login in"   
			end
	end
end


end
