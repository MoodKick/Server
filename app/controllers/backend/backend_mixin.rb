module Backend
  module BackendMixin
    def has_claim?(claim)
      principal.has_claim?(current_user, claim)
    end

    def current_user
      current_backend_user
    end

    def self.included m
      return unless m < ActionController::Base
      m.helper_method :has_claim?

      m.layout 'backend_layout'
    end

    protected
      def principal
        ServiceContainer.principal
      end
  end
end
