module Api::V1

    class QuestionTilesController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::QuestionTileSerializer
        before_action :current_question_tile, only: [:update, :destroy]
        before_action :tile_tags_processor, only: [:create, :update]

        def create
            question_tile = @extracted_user.tiles.create!(tile_and_tile_question_params_for_create)

            @tile_tags_processor.process_tile_taggings(tile_tags_ids_array_from_params, question_tile, :create)
            
            render json: serialize_question_tile(question_tile), status: :ok
        end

        def update
            @current_question_tile.update!(tile_and_tile_question_params_for_update)
            
            @tile_tags_processor.process_tile_taggings(tile_tags_ids_array_from_params, @current_question_tile, :update)

            render json: serialize_question_tile(@current_question_tile), status: :ok
        end

        def destroy
            @current_question_tile.destroy

            render json: {message: "Tile was successfully deleted"}, status: :ok
        end

        private

            def tile_and_tile_question_params_for_create
                params[:tile_question_attributes] = params.delete(:tile_question)
                params.permit(:tile_type, :tile_type_name, :tile_type_color, :tile_title, :tile_description,
                            :tile_activities_sets, tile_question_attributes: [:tile_ask_question,
                            :tile_answer_numeric, :tile_answer_numeric_from, :tile_answer_numeric_to,
                            :tile_answers_descriptives])
            end

            def tile_and_tile_question_params_for_update
                params[:tile_question_attributes] = params.delete(:tile_question)
                params.permit(:tile_type, :tile_type_name, :tile_type_color, :tile_title, :tile_description,
                            :tile_activities_sets, tile_question_attributes: [:id, :tile_ask_question,
                            :tile_answer_numeric, :tile_answer_numeric_from, :tile_answer_numeric_to,
                            :tile_answers_descriptives, :_destroy])
            end

            def tile_tags_ids_array_from_params
                params.permit(tile_tags: [])[:tile_tags]
            end

            def current_question_tile
                @current_question_tile = @extracted_user.tiles.find(params[:id])
            end

            def tile_tags_processor
                @tile_tags_processor = TileTagsProcessor.new(@extracted_user)
            end
    end

end

# Controller for role: trainer.
# -------------------------------------------------------------
# Description in training_tiles_controller.