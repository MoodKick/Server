MoodKick::Application.routes.draw do

  get '/backend/admin/therapists/:therapist_id/clients/new', to: 'Backend::Admin::TherapistClients#new', as: 'new_backend_admin_therapist_client'
  post '/backend/admin/therapists/:therapist_id/clients', to: 'Backend::Admin::TherapistClients#create', as: 'backend_admin_therapist_clients'

  namespace :backend do
    root to: 'home#show'
    devise_for :users, class_name: 'User', module: 'backend'

    namespace :admin do
      resources :users, only: [:index, :show, :edit, :update, :destroy, :new, :create] do
        resources :roles, only: [:index, :create]
        delete '/roles', to: 'roles#destroy'
      end
      resources :content_objects, only: [:index, :show] do
        post 'update_all', on: :collection
      end
    end

    namespace :client do
      resource :safety_plan, controller: 'SafetyPlans', only: [:show]
      resources :hope_items, controller: 'HopeItems', only: [:index, :destroy, :edit, :update] do
        get '/new_text', to: 'hope_items#new_text', on: :collection
        post '/text', to: 'hope_items#create_text', on: :collection
      end
    end
    namespace :therapist do
      resources :brochures, only: [:index, :show, :edit, :update]
      resources :clients do
        resources :daily_journal_entries, controller: 'ClientDailyJournalEntries' do
          resource :audio, controller: 'ClientDailyJournalEntryAudios', only: [:show]
          resource :video, controller: 'ClientDailyJournalEntryVideos', only: [:show]
        end
        resource :safety_plan, controller: 'ClientSafetyPlans', only: [:show, :edit, :create, :update]
        resource :mood_trend, controller: 'ClientMoodTrends'
        resources :questionnaires, controller: 'ClientQuestionnaires', only: [:index] do
          resources :results, controller: 'ClientQuestionnaireResults', only: [:index, :show]
        end
      end
      resources :questionnaires, controller: 'Questionnaires', only: [:index] do
        resources :results, controller: 'QuestionnaireQuestionnaireResults', only: [:index]
      end
      resources :questionnaire_results, controller: 'QuestionnaireResults', only: [:show]
    end
  end


  namespace :clients do
    devise_for :clients, class_name: 'User', module: 'clients'
  end

  namespace :therapists do
    root to: 'clients#index'
    get 'access_denied' => 'access_denied#show'

    devise_for :therapists, class_name: 'User', module: 'therapists'
  end

  match '*anything' => 'api/v1/cors#index', :constraints => { :method => 'OPTIONS' }

  namespace :api do
    namespace :v1 do
      devise_for :users, controllers: { registrations: 'Api::V1::Registrations' }
      resources :brochures, only: [:show]
      resources :tokens, only: [:create, :destroy]
      resources :users, only: [:index, :show]
      resources :contacts, only: [:index, :create, :show, :destroy]
      delete 'contacts/by_user/:id' => 'contacts#destroy_by_user'
      resources :messages, only: [:index]
      resource :profile, only: [:show, :update], controller: 'Profiles'
      resource :mood_trend, only: [:show]
      resources :avatars, only: [:index]
      resources :questionnaires, only: [:index]
      resources :answer_groups, only: [:create]
      resources :content_objects, only: [:index, :show] do
        post 'launches', to: 'content_objects#create_launch'
      end
      resource :safety_plan, only: [:show]
      resources :daily_journals do
        resource :audio, controller: 'DailyJournalAudios'
        resource :video, controller: 'DailyJournalVideos'
      end
    end
  end
end
