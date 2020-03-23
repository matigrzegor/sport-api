module Api::V1

    module MembershipErrorer
        
        def validation_error_one
            {
                error: {
                    status: "Bad Request",
                    code: 400,
                    message: "Validation error",
                    reference_code: 70041
                }
            }
        end
    end

end