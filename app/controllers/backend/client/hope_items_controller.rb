module Backend module Client
  class HopeItemsController < ClientController
    class IndexResponder < Responder
      def success(list)
        render locals: {
          hope_items: list
        }
      end
    end

    def index
      hope_items = service.list(current_user, IndexResponder.new(self))
    end

    class EditResponder < Responder
      def success(item)
        render locals: {
          hope_item: item,
          errors: []
        }
      end
    end

    def edit
      service.find(current_user, params[:id], EditResponder.new(self))
    end

    class UpdateResponder < Responder
      def success(item)
        flash[:notice] = 'Successfully updated hope item.'
        redirect_to backend_client_hope_items_path
      end
    end

    def update
      service.update_text(current_user, params[:id],
                          params[:hope_item][:title],
                          params[:hope_item][:text],
                          UpdateResponder.new(self))
    end

    class DestroyResponder < Responder
      def success
        flash[:notice] = 'Successfully removed hope item.'
        redirect_to backend_client_hope_items_path
      end
    end

    def destroy
      service.delete(current_user, params[:id], DestroyResponder.new(self))
    end

    def new_text
      render locals: {
        hope_item: service.build_new_text(current_user),
        errors: []
      }
    end

    class CreateTextResponder < Responder
      def not_valid(hope_item, errors)
        render action: :new_text, locals: {
          errors: errors,
          hope_item: hope_item
        }
      end

      def success
        flash[:notice] = 'Successfully added hope item.'
        redirect_to backend_client_hope_items_path
      end
    end

    def create_text
      service.add_text(current_user,
                       params[:hope_item][:title],
                       params[:hope_item][:text],
                       CreateTextResponder.new(self))
    end

    private
      def service
        ServiceContainer.client_chest_of_hope_service
      end
  end
end end
