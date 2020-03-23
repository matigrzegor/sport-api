module Api::V1

    class CustomAthleteParametersController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::CustomAthleteParameterSerializer
        before_action :current_athlete_platform, only: [:create, :destroy, :update]
        before_action :current_custom_athlete_parameter, only: [:destroy, :update]

        def create
            custom_athlete_parameter = @current_athlete_platform.custom_athlete_parameters
                                                .create!(custom_athlete_parameter_params)

            render json: serialize_custom_athlete_parameter(custom_athlete_parameter), status: :ok
        end

        def update
            @current_custom_athlete_parameter.update!(custom_athlete_parameter_params)

            render json: serialize_custom_athlete_parameter(@current_custom_athlete_parameter), status: :ok
        end

        def destroy
            @current_custom_athlete_parameter.destroy

            render json: {message: "Custom athlete parameter was successfully deleted"}, status: :ok
        end

        private

            def custom_athlete_parameter_params
                params.permit(:parameter_name, :parameter_date, :parameter_description)
            end

            def current_athlete_platform
                @current_athlete_platform = @extracted_user.athlete_platforms.find(params[:athlete_platform_id])
            end

            def current_custom_athlete_parameter
                @current_custom_athlete_parameter = @current_athlete_platform.custom_athlete_parameters.find(params[:id])
            end

    end

end

# Controller for role: trainer.