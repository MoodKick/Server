module Api
  module V1
    class TokensController < ApiController
      skip_before_filter :verify_authenticity_token
      respond_to :json

      def create
        #FIXME: handle lack of :user
        username = params[:user][:username]
        password = params[:user][:password]

        if request.format != :json
          render status: 406, json: { message: "The request must be json" }
          return
        end

        if username.nil? || password.nil? 
          render status: 400, json: { message: "The request must contain the user username and password." }
          return
        end

        @user = User.find_by_username(username)

        if @user.nil?
          logger.info("User #{username} failed signin, user cannot be found.")
          render status: 401, json: { message: "Invalid username or passoword." }
          return
        end

        @user.ensure_authentication_token
        @user.save!

        unless @user.valid_password?(password)
          logger.info("User #{username} failed signin, password \"#{password}\" is invalid")
          render status: 401, json: { message: "Invalid username or passoword." }
        else
          render status: 200
        end
      end

      def destroy
        @user = User.find_by_authentication_token(params[:id])
        if @user.nil?
          logger.info("Token not found.")
          render status: 404, json: { message: "Invalid token." }
        else
          @user.reset_authentication_token!
          render status: 200, json: { token: params[:id] }
        end
      end
    end
  end
end
