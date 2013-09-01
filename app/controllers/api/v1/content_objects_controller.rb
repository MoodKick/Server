module Api
  module V1
    class ContentObjectsController < ApiController
      before_filter :authenticate_user!

      def index
        @content_objects = service.list
        respond_to do |format|
          format.json { render status: 200 }
        end
      end

      def show
        @content_object = service.show(params[:id])
        respond_to do |format|
          format.json { render status: 200 }
        end
      end

      def create_launch
        service.launched(params[:content_object_id])
        respond_to do |format|
          format.json { render status: :created, json: '{ "status": "OK" }' }
        end
      end

      private
        def service
          ServiceContainer.content_object_service
        end
    end
  end
end
