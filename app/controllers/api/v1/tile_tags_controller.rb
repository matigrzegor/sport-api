module Api::V1
    
    class TileTagsController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::TileTagSerializer
        before_action :current_tile_tag, only: :destroy

        def index
            tile_tags = @extracted_user.tags.all

            render json: serialize_tile_tags(tile_tags), status: 200
        end

        def create
            tile_tag = @extracted_user.tags.create!(tag_params)

            render json: serialize_tile_tag(tile_tag), status: 200
        end
    
        def destroy
            @current_tile_tag.destroy

            render json: {message: 'Tile tag was successfully deleted.'}, status: 200
        end

        private
            
            def tag_params
                params.permit(:tag_name)
            end

            def current_tile_tag
                @current_tile_tag = @extracted_user.tags.find(params[:id])
            end

    end
    
end

# Controller for role: trainer.