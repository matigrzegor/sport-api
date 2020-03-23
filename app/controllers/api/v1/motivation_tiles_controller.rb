module Api::V1

    class MotivationTilesController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::MotivationTileSerializer
        before_action :current_motivation_tile, only: [:update, :destroy]
        before_action :tile_tags_processor, only: [:create, :update]

        def create
            motivation_tile = @extracted_user.tiles.create!(tile_and_tile_motivation_params_for_create)

            @tile_tags_processor.process_tile_taggings(tile_tags_ids_array_from_params, motivation_tile, :create)
            
            render json: serialize_motivation_tile(motivation_tile), status: :ok
        end
    
        def update
            @current_motivation_tile.update!(tile_and_tile_motivation_params_for_update)

            @tile_tags_processor.process_tile_taggings(tile_tags_ids_array_from_params, @current_motivation_tile, :update)

            render json: serialize_motivation_tile(@current_motivation_tile), status: :ok
        end

        def destroy
            @current_motivation_tile.destroy

            render json: {message: "Tile was successfully deleted"}, status: :ok
        end

        private

            def tile_and_tile_motivation_params_for_create
                params[:tile_motivation_attributes] = params.delete(:tile_motivation)
                params.permit(:tile_type, :tile_type_name, :tile_type_color, :tile_title, :tile_description,
                            :tile_activities_sets, :tile_tags, tile_motivation_attributes:
                            [:tile_motivation_sentence, :tile_motivation_link])
            end

            def tile_and_tile_motivation_params_for_update
                params[:tile_motivation_attributes] = params.delete(:tile_motivation)
                params.permit(:tile_type, :tile_type_name, :tile_type_color, :tile_title, :tile_description,
                            :tile_activities_sets, :tile_tags, tile_motivation_attributes:
                            [:id, :tile_motivation_sentence, :tile_motivation_link, :_destroy])
            end

            def tile_tags_ids_array_from_params
                params.permit(tile_tags: [])[:tile_tags]
            end

            def current_motivation_tile
                @current_motivation_tile = @extracted_user.tiles.find(params[:id])
            end

            def tile_tags_processor
                @tile_tags_processor = TileTagsProcessor.new(@extracted_user)
            end
    end

end

# Controller for role: trainer.
# -------------------------------------------------------------
# Description in training_tiles_controller.