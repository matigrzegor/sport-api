module Api::V1

    class DietTilesController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::DietTileSerializer
        before_action :current_diet_tile, only: [:update, :destroy]
        before_action :tile_tags_processor, only: [:create, :update]

        def create
            diet_tile = @extracted_user.tiles.create!(tile_and_tile_diets_with_tile_diet_nutrients_params_for_create)

            @tile_tags_processor.process_tile_taggings(tile_tags_ids_array_from_params, diet_tile, :create)
            
            render json: serialize_diet_tile(diet_tile), status: :ok
        end
    
        def update
            @current_diet_tile.update!(tile_and_tile_diets_with_tile_diet_nutrients_params_for_update)

            @tile_tags_processor.process_tile_taggings(tile_tags_ids_array_from_params, @current_diet_tile, :update)

            render json: serialize_diet_tile(@current_diet_tile), status: :ok
        end

        def destroy
            @current_diet_tile.destroy

            render json: {message: "Tile was successfully deleted"}, status: :ok
        end

        private

            def tile_and_tile_diets_with_tile_diet_nutrients_params_for_create
                params[:tile_diets_attributes] = params.delete(:tile_diets)
                params[:tile_diets_attributes].each { |elem| elem[:tile_diet_nutrients_attributes] = elem.delete(:tile_diet_nutrients) }
                params.permit(:tile_type, :tile_type_name, :tile_type_color, :tile_title, :tile_description,
                            :tile_activities_sets, :tile_tags, {tile_diets_attributes: [:tile_diet_meal,
                            :tile_diet_energy_unit, :tile_diet_energy_amount, :tile_diet_carbohydrates_unit,
                            :tile_diet_carbohydrates_amount, :tile_diet_protein_unit, :tile_diet_protein_amount,
                            :tile_diet_fat_unit, :tile_diet_fat_amount, :tile_diet_note,
                            {tile_diet_nutrients_attributes: [:tile_diet_nutrient_name, :tile_diet_nutrient_unit,
                            :tile_diet_nutrient_amount]}]})
            end

            def tile_and_tile_diets_with_tile_diet_nutrients_params_for_update
                params[:tile_diets_attributes] = params.delete(:tile_diets)
                params[:tile_diets_attributes].each { |elem| elem[:tile_diet_nutrients_attributes] = elem.delete(:tile_diet_nutrients) }
                params.permit(:tile_type, :tile_type_name, :tile_type_color, :tile_title, :tile_description,
                            :tile_activities_sets, :tile_tags, {tile_diets_attributes: [:id, :tile_diet_meal,
                            :tile_diet_energy_unit, :tile_diet_energy_amount, :tile_diet_carbohydrates_unit,
                            :tile_diet_carbohydrates_amount, :tile_diet_protein_unit, :tile_diet_protein_amount,
                            :tile_diet_fat_unit, :tile_diet_fat_amount, :tile_diet_note, :_destroy,
                            {tile_diet_nutrients_attributes: [:id, :tile_diet_nutrient_name, :tile_diet_nutrient_unit,
                            :tile_diet_nutrient_amount, :_destroy]}]})
            end

            def tile_tags_ids_array_from_params
                params.permit(tile_tags: [])[:tile_tags]
            end

            def current_diet_tile
                @current_diet_tile = @extracted_user.tiles.find(params[:id])
            end

            def tile_tags_processor
                @tile_tags_processor = TileTagsProcessor.new(@extracted_user)
            end
    end

end

# Controller for role: trainer.
# -------------------------------------------------------------
# Description in training_tiles_controller.
