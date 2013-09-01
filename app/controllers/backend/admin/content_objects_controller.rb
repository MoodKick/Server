module Backend module Admin
  class ContentObjectsController < AdminController
    class ListResponder < Responder
      def success(content_objects)
        render locals: {
          content_objects: content_objects
        }
      end
    end

    def index
      service.list(ListResponder.new(self))
    end

    class UpdateAllResponder < Responder
      def success
        redirect_to backend_admin_content_objects_path
      end
    end

    def update_all
      service.update_all(UpdateAllResponder.new(self))
    end

    class ShowResponder < Responder
      def success(content_object)
        render locals: {
          content_object: content_object
        }
      end
    end

    def show
      service.show(params[:id], ShowResponder.new(self))
    end

    private
      def service
        ServiceContainer.content_object_service
      end
  end
end end
