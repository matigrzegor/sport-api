module Api::V1

    module QueueInvitationErrorer
        
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
                    reference_code: 70131
                }
            }
        end

    end

end