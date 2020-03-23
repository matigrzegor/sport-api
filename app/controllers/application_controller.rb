class ApplicationController < ActionController::API

    rescue_from ActiveRecord::RecordNotFound do
        render json: Errorer::ErrorCreator.new(:application).create_error(404, 1),
                     status: 404
    end

    rescue_from ActiveRecord::RecordInvalid do
        render json: Errorer::ErrorCreator.new(:application).create_error(400, 2),
                     status: 400
    end

end
