module Api::V1

    class TrainingPlansController < ApplicationController
        include Secured
        include TrainerRoled
        include Api::V1::TrainingPlanSerializer
        before_action :error_creator, only: :create
        before_action :check_access_to_make_training_plans, only: :create
        before_action :current_training_plan, only: [:show, :destroy, :update]

        def index
            training_plans = @extracted_user.training_plans.all.uniq

            limited_training_plans = @account_checker.return_limited_resources(:training_plans, training_plans)

            render json: serialize_index_training_plans(limited_training_plans), status: :ok
        end

        def show
            render json: serialize_full_training_plan(@current_training_plan), status: :ok
        end
        
        def create
            training_plan = @extracted_user.training_plans.create!(training_plan_params)
            
            render json: serialize_training_plan(training_plan), status: :ok
        end
        
        def update
            @current_training_plan.update!(training_plan_params)

            render json: serialize_full_training_plan(@current_training_plan), status: :ok
        end

        def destroy
            @current_training_plan.destroy

            render json: {message: "Training plan was successfully deleted"}, status: :ok
        end

        private

            def training_plan_params
                params.permit(:training_plan_name, :date_from, :date_to, :training_sesion_number)
            end     

            def current_training_plan
                @current_training_plan = @extracted_user.training_plans.find(params[:id])
            end

            def error_creator
                @error_creator = Errorer::ErrorCreator.new(:training_plans)
            end

            def check_access_to_make_training_plans
                if @account_checker.permitted_to_make_training_plan? == false
                    render json: @error_creator.create_error(403, 1), status: 403
                end
            end
    end

end

# Controller for role: trainer.