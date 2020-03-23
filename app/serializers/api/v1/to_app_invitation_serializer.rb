module Api::V1
    
    module ToAppInvitationSerializer

        def serialize_pending_user_invitation(pending_user_invitation)
            {
                id: pending_user_invitation.id
            }
        end
    
    end
end