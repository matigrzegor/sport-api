module Api::V1

    class TrainingTilesController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::TrainingTileSerializer
        before_action :current_training_tile, only: [:update, :destroy]
        before_action :tile_tags_processor, only: [:create, :update]

        def create
            training_tile = @extracted_user.tiles.create!(tile_and_tile_activities_params_for_create)

            @tile_tags_processor.process_tile_taggings(tile_tags_ids_array_from_params, training_tile, :create)
            
            render json: serialize_training_tile(training_tile), status: :ok
        end
        
        def update
            @current_training_tile.update!(tile_and_tile_activities_params_for_update)

            @tile_tags_processor.process_tile_taggings(tile_tags_ids_array_from_params, @current_training_tile, :update)

            render json: serialize_training_tile(@current_training_tile), status: :ok
        end

        def destroy
            @current_training_tile.destroy

            render json: {message: "Tile was successfully deleted"}, status: :ok
        end

        private

            def tile_and_tile_activities_params_for_create
                params[:tile_activities_attributes] = params.delete(:tile_activities)
                
                params.permit(:tile_type, :tile_type_name, :tile_type_color, :tile_title, :tile_description,
                            :tile_activities_sets, :tile_activities_sets_rest_unit, :tile_activities_sets_rest_amount,
                            :tile_activities_sets_rest_intensity_unit, :tile_activities_sets_rest_intensity_amount,
                            {tile_activities_attributes: [:tile_activity_name,
                            :tile_activity_reps, :tile_activity_unit, :tile_activity_amount, :tile_activity_intensity,
                            :tile_activity_intensity_amount, :tile_activity_rest_unit, :tile_activity_rest_amount,
                            :tile_activity_rest_intensity, :tile_activity_rest_intensity_amount,
                            :tile_activity_note, :tile_activity_rest_after_activity_unit,
                            :tile_activity_rest_after_activity_amount, :tile_activity_rest_after_activity_intensity,
                            :tile_activity_rest_after_activity_intensity_amount]})
                
            end

            def tile_and_tile_activities_params_for_update
                params[:tile_activities_attributes] = params.delete(:tile_activities) 
                
                params.permit(:tile_type, :tile_type_name, :tile_type_color, :tile_title, :tile_description,
                            :tile_activities_sets, :tile_activities_sets_rest_unit, :tile_activities_sets_rest_amount,
                            :tile_activities_sets_rest_intensity_unit, :tile_activities_sets_rest_intensity_amount,
                            {tile_activities_attributes: [:id, :tile_activity_name,
                            :tile_activity_reps, :tile_activity_unit, :tile_activity_amount, :tile_activity_intensity,
                            :tile_activity_intensity_amount, :tile_activity_rest_unit, :tile_activity_rest_amount,
                            :tile_activity_rest_intensity, :tile_activity_rest_intensity_amount,
                            :tile_activity_note, :tile_activity_rest_after_activity_unit,
                            :tile_activity_rest_after_activity_amount, :tile_activity_rest_after_activity_intensity,
                            :tile_activity_rest_after_activity_intensity_amount, :_destroy]})
            end

            def tile_tags_ids_array_from_params
                params.permit(tile_tags: [])[:tile_tags]
            end

            def current_training_tile
                @current_training_tile = @extracted_user.tiles.find(params[:id])
            end

            def tile_tags_processor
                @tile_tags_processor = TileTagsProcessor.new(@extracted_user)
            end
    end

end

# Controller for role: trainer.
# --------------------------------------------------------------------
# This controller serves training tile resource which means: Tile model with TileActivities associations.
# The same is with question, motivation and diet tiles controllers.