Rails.application.routes.draw do

    namespace :api do
        
        namespace :v1 do
            # tiles routes - Tile model with all its associations
            resources :tiles, only: :index

            # tile_tags routes
            resources :tile_tags, only: [:index, :create, :destroy]

            # training tiles routes - Tile model with TileActivity associations
            resources :training_tiles, only: [:create, :update, :destroy]

            # question tiles routes - Tile model with TileQuestion associations
            resources :question_tiles, only: [:create, :update, :destroy]
            
            # diet tiles routes - Tile model with TileDiet associations with TileDietNutrient associations
            resources :diet_tiles, only: [:create, :update, :destroy]

            # motivation tiles routes - Tile model with TileMotivation association
            resources :motivation_tiles, only: [:create, :update, :destroy]

            # trainingplans routes, calendar_assocs routes, board_notes routes and calendar_stars routes:
            resources :training_plans, only: [:index, :show, :create, :destroy, :update] do
                resources :calendar_assocs, only: [:create, :destroy, :update]
                post 'mass_index_update', to: 'calendar_assocs#mass_index_update'
                post 'calendar_assocs_mass_create', to: 'calendar_assocs#mass_create'
                patch 'calendar_assocs_mass_destroy', to: 'calendar_assocs#mass_destroy'
                resources :training_plan_board_notes, only: [:index, :create, :destroy, :update]
                resources :calendar_stars, only: [:create, :destroy, :update]
                resources :training_plan_question_answers, only: :index
                resources :calendar_comments, only: [:create, :destroy, :update]
            end

            # belonging to user board_notes routes:
            resources :user_board_notes, only: [:index, :create, :destroy, :update]

            # athlete_platforms routes, platform_notes routes, custom_athlete_parameters routes,
            # invitations routes and memberships routes
            resources :athlete_platforms, only: [:index, :show, :create, :destroy, :update] do
                resources :platform_notes, only: [:create, :destroy, :update]
                resources :custom_athlete_parameters, only: [:create, :destroy, :update]
                resources :plan_appends, only: [:create, :destroy]
                #put 'plan_appends/:id/activate', to: 'plan_appends#activate'
                #put 'plan_appends/:id/inactivate', to: 'plan_appends#inactivate'
                resources :invitations, only: [:create, :destroy]
                resources :memberships, only: :destroy
                resources :to_app_invitations, only: [:create, :destroy]
                get 'athlete_status', to: 'athlete_statuses#show'
            end

            resources :queue_invitations, only: :create
            
            # attendant_memberships routes
            post 'attendant_memberships', to: 'attendant_memberships#create'
            get 'attendant_membership', to: 'attendant_memberships#show'
            delete 'attendant_membership', to: 'attendant_memberships#destroy'

            # platform_training_plan and platform_training_plan_board_notes
            # and platform_training_plan_question_answers routes
            get 'platform_training_plan', to: 'platform_training_plans#show'
            get 'platform_training_plan_board_notes', to: 'platform_training_plan_board_notes#show'
            post 'platform_training_plan_question_answers', to: 'platform_training_plan_question_answers#create'
            get 'platform_training_plan_question_answer_metadata', to: 'platform_training_plan_question_answer_metadata#index'
            get 'platform_training_plan_tiles', to: 'platform_training_plan_tiles#index'
            resources :platform_training_plan_calendar_comments, only: [:create, :destroy, :update] 

            # routy dla athleted_invitations
            delete 'athleted_invitations/:platform_token', to: 'athleted_invitations#destroy'
            get 'athleted_invitations', to: 'athleted_invitations#index'

            # routy do auth_metadata
            resources :auth_metadata, only: [:create, :destroy]
            
            # routy do user_account_searches
            resources :user_account_searches, only: :create

            # routy do trial
            post 'create_trial', to: 'trials#create_trial'
            put 'end_trial', to: 'trials#end_trial'

            # routy do stripe subscriptions
            post 'create_first_stripe_subscription', to: 'stripe_subscriptions#create_first_subscription'
            post 'create_stripe_subscription', to: 'stripe_subscriptions#create_subscription'
            put 'cancel_stripe_subscription', to: 'stripe_subscriptions#cancel_subscription'
            post 'preview_proration', to: 'stripe_subscriptions#preview_proration'
            put 'update_stripe_subscription', to: 'stripe_subscriptions#update_subscription'
            

            # routy do stripe webhooków
            post 'stripe_event', to: 'stripe_webhooks#stripe_event'

            # rout do in_app_feedbacks
            resources :in_app_feedbacks, only: :create

            # short_polling_invitation_permissions
            get 'invitation_stream_status', to: 'invitation_stream_statuses#show'

            # initial_tile_collections routes
            resources :initial_tile_collections, only: :create

            # users routes - delete narazie
            delete 'user', to: 'users#destroy'

            get 'connection_verification_token', to: 'connection_verification_tokens#get_token'
            
        end
    
    end

end

# routes starts with /api/vx/... - x is a version (1,2,3)
