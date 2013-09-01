module Api
  module V1
    class ApiController < ApplicationController
      protect_from_forgery

      after_filter :cors_set_access_control_headers

      def authenticate_user!
        #FIXME: there is no way to tell warden not to search for authenticated user
        # in a session
        env['rack.session'] = {}
        warden.authenticate!(:token_authenticatable, { scope: :api_v1_user, store: false })
      end

      def current_user
        current_api_v1_user
      end

      def cors_set_access_control_headers
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
        headers['Access-Control-Max-Age'] = "1728000"
      end
    end
  end
end
