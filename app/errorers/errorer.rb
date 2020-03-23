module Errorer
    
    REFERENCE_CODE_BASES = {
        :application    => 70000,
        :secured => 70010,
        :athlete_roled => 70020,
        :trainer_roled => 70030,
        :stripe_subscriptions => 70120,
        :trials => 70130,
        :athleted => 70140,
        :athleted_invitations => 70150,
        :attendant_memberships => 70160,
        :athlete_platforms => 70170,
        :training_plans => 70180,
        :invitations => 70190,
        :pending_user_invitations => 70200,
        :users => 70210,
        :calendar_comments => 70220,
        :platform_training_plan_calendar_comments => 70230,
        :platform_messages => 70240,
        :memberships => 70250
    }

    MAIN_ERROR_PARTS = {
        404 => {status: "Not Found",
                code: 404,
                message: "Resource is not found"},
        500 => {status: "Internal Server Erro",
                code: 500,
                message: "Something went wrong in our system. Please contact our support"},
        400 => {status: "Bad Request",
                code: 400,
                message: "Validation error"},
        401 => {status: "Unauthorized",
                code: 401,
                message: "Unauthorized"},
        403 => {status: "Forbidden",
                code: 403,
                message: "Access forbidden"}
    }

    SPECIFIC_ERRORS = {
        :auth0_management_token_error => MAIN_ERROR_PARTS[500].merge({reference_code: 50001}),
        :paid_account_downgrade => MAIN_ERROR_PARTS[403].merge({message: "Paid account need to be downgraded",
                                                                reference_code: 24301}),
        :trial_account_downgrade => MAIN_ERROR_PARTS[403].merge({message: "Trial account need to be downgraded",
                                                                 reference_code: 24302})                                                  
    }

end