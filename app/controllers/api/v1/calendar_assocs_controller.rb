module Api::V1

    class CalendarAssocsController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::CalendarAssocSerializer
        before_action :current_training_plan, only: [:create, :update, :destroy, :mass_index_update, :mass_create, :mass_destroy]
        before_action :current_calendar_assoc, only: [:destroy, :update]

        def create
            calendar_assoc = @current_training_plan.calendar_assocs.create!(create_params)
            
            QuestionAnswerSystemProcessor.new.create_metadatum(calendar_assoc)

            render json: serialize_calendar_assoc(calendar_assoc), status: :ok
        end

        def update
            @current_calendar_assoc.update!(update_params)

            QuestionAnswerSystemProcessor.new.update_asso_index_in_metadatum(@current_calendar_assoc)

            render json: serialize_calendar_assoc(@current_calendar_assoc), status: :ok
        end

        def destroy
            @current_calendar_assoc.destroy
            
            render json: {message: "Calendar assoc was successfully deleted"}, status: :ok
        end

        def mass_index_update
            updated_calendar_assocs = mass_update_index_in_calendar_assocs

            render json: serialize_calendar_assocs(updated_calendar_assocs), status: :ok
        end

        def mass_create
            calendar_assocs = @current_training_plan.calendar_assocs.create!(calendar_assocs_params_for_mass_create)
            
            QuestionAnswerSystemProcessor.new.create_metadata(calendar_assocs)

            render json: serialize_calendar_assocs(calendar_assocs), status: :ok
        end

        def mass_destroy
            calendar_assocs_ids = calendar_assocs_params_for_mass_destroy
            
            calendar_assocs_ids[:calendar_assocs].each do |id|
                calendar_assoc = @current_training_plan.calendar_assocs.find_by(id: id)

                if calendar_assoc != nil
                    calendar_assoc.destroy
                end
            end

            render json: {message: "Calendar assocs was successfully deleted"}, status: :ok
        end

        private

            def create_params
                params.permit(:tile_id, :tile_color, :calendar_date, :training_sesion, :asso_index_in_array)
            end
            
            def update_params
                params.permit(:training_sesion, :asso_index_in_array)
            end
            
            def mass_update_index_in_calendar_assocs
                permitted_params = params.permit({ calendar_assocs: [:id, :asso_index_in_array] })

                updated_calendar_assocs = []

                permitted_params[:calendar_assocs].map do |elem|
                    calendar_assoc = @current_training_plan.calendar_assocs.find(elem[:id])

                    calendar_assoc.asso_index_in_array = elem[:asso_index_in_array]
                    calendar_assoc.save!

                    updated_calendar_assocs << calendar_assoc
                end

                updated_calendar_assocs
            end

            def calendar_assocs_params_for_mass_create
                permitted_params = params.permit({calendar_assocs: [:tile_id, :tile_color, :calendar_date, 
                                                                    :training_sesion, :asso_index_in_array]})
                
                valideted_params = []

                permitted_params[:calendar_assocs].each do |assoc_params|
                    tile = @extracted_user.tiles.find_by(id: assoc_params[:tile_id])
                    
                    if tile != nil
                        valideted_params << assoc_params
                    end
                end

                valideted_params
            end

            def calendar_assocs_params_for_mass_destroy
                params.permit(calendar_assocs: [])
            end

            # ta akcja zwraca training_plan usera po id training_planu z uri'a
            def current_training_plan
                @current_training_plan = @extracted_user.training_plans.find(params[:training_plan_id])
            end

            # ta akcja zwraca calendar_assoc po id z uri'a
            def current_calendar_assoc
                @current_calendar_assoc = @current_training_plan.calendar_assocs.find(params[:id])
            end

    end

end

# Controller for role: trainer.
# -----------------------------------------------------------------------
# Calendar assocs (model: calendar_assoc) connect tiles (which reflect workouts/diets/notes/questions) with dates on 
# a training plan.