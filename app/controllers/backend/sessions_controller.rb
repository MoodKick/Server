module Backend
  class SessionsController < Devise::SessionsController
    include BackendMixin

    def after_sign_in_path_for(resource)
      backend_root_path
    end

    def after_sign_out_path_for(resource_name)
      backend_root_path
    end
  end
end
