module Api::V1

    class PlanAppendsController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::PlanAppendSerializer
        include Api::V1::PlanAppendErrorer
        before_action :current_athlete_platform, only: [:create, :destroy, :activate, :inactivate]
        before_action :current_training_plan, only: :create
        before_action :current_plan_append, only: [:destroy, :activate, :inactivate]


        def create
            plan_append = @current_athlete_platform.plan_appends.create!(training_plan_id: @current_training_plan.id,
                                                        training_plan_name: @current_training_plan.training_plan_name)

            plan_append.activate_on_platform
            
            render json: serialize_plan_append(plan_append), status: :ok
        end

        def destroy
            @current_plan_append.destroy

            render json: {message: "Training plan was successfully removed from the platform"}, status: :ok
        end

        def activate
            @current_plan_append.activate_on_platform

            render json: serialize_plan_append(@current_plan_append), status: :ok
        end

        def inactivate
            @current_plan_append.inactivated!

            render json: serialize_plan_append(@current_plan_append), status: :ok
        end

        private

            def plan_append_params
                params.permit(:training_plan_id)
            end

            def current_athlete_platform
                @current_athlete_platform = @extracted_user.athlete_platforms.find(params[:athlete_platform_id])
            end

            def current_training_plan
                current_training_plan = @extracted_user.training_plans.find(plan_append_params[:training_plan_id])
                if current_training_plan.plan_appends.count == 1
                    render json: {message: 'This training plan is appended to your another athlete card'}, status: 200
                elsif current_training_plan.plan_appends.count == 0
                    @current_training_plan = current_training_plan
                end
            end

            def current_plan_append
                @current_plan_append = @current_athlete_platform.plan_appends.find(params[:id])
            end
            
    end

end

# Controller for role: trainer.