module Api::V1
    
    class PlatformTrainingPlansController < ApplicationController
        include Secured
        include AthleteRoled
        include Athleted
        include Api::V1::TrainingPlanSerializer

        def show
            training_plan = @plan_append.training_plan

            render json: serialize_full_training_plan(training_plan), status: :ok
        end

    end

end

# Controller for role: athlete.
# ---------------------------------------------------
# With this controller athlete can get the training plan that the trainer shared with him on the athlete platoform.