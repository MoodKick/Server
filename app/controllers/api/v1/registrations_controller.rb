module Api
  module V1
    class RegistrationsController < ApiController
      def create
        respond_to do |format|
          format.html do
            super
          end
          format.json do
            build_resource
            resource.ensure_authentication_token
            if resource.save
              render status: 200
            else
              render json: resource.errors, status: :unprocessable_entity
            end
          end
        end
      end
    end
  end
end
