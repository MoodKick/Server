module Api
  module V1
    class ContactsController < ApiController
      before_filter :authenticate_user!

      def index
        @contacts = current_user.contacts

        respond_to do |format|
          format.json { render status: 200 }
        end
      end

      def create
        @contact = Contact.new
        @contact.user_id = params[:contact][:user_id]
        @contact.owner_id = current_user.id

        respond_to do |format|
          if @contact.save
            format.json { render status: :created, location: api_v1_contact_path(@contact) }
          else
            format.json { render json: @contact.errors, status: :unprocessable_entity }
          end
        end
      end

      def destroy
        @contact = Contact.find(params[:id])
        @contact.destroy

        respond_to do |format|
          format.json { head :no_content }
        end
      end

      def destroy_by_user
        #FIXME: that's terrible
        contact = current_user.contacts.all.find { |c| c.user_id == params[:id].to_i }
        contact.destroy

        respond_to do |format|
          format.json { head :no_content }
        end
      end
    end
  end
end
