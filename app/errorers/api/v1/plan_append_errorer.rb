module Api::V1
        
    module PlanAppendErrorer
        
        def validation_error_one
            {
                error: {
                    status: "Bad Request",
                    code: 400,
                    message: "Validation error",
                    reference_code: 70031
                }
            }
        end     
    end
end