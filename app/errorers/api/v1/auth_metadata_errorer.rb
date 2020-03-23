module Api::V1

    module AuthMetadataErrorer
        
        def auth0_management_token_error
            {
                error: {
                    status: "Internal Server Error",
                    code: 500,
                    message: "Something went wrong in our system. Please contact our support",
                    reference_code: 70011
                }
            }
        end

        def auth0_error_one
            {
                error: {
                    status: "Internal Server Error",
                    code: 500,
                    message: "Something went wrong in our system. Please contact our support",
                    reference_code: 70081
                }
            }
        end

        def auth0_error_two
            {
                error: {
                    status: "Internal Server Error",
                    code: 500,
                    message: "Something went wrong in our system. Please contact our support",
                    reference_code: 70083
                }
            }
        end

        def validation_error_one
            {
                error: {
                    status: "Bad Request",
                    code: 400,
                    message: "Validation error",
                    reference_code: 70082
                }
            }
        end

    end

end