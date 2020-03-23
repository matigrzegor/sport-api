module Api::V1
    
    module InvitationSerializer

        def serialize_invitation(invitation)
            {
                id: invitation.id
            }
        end

        def serialize_full_invitation(invitation_data)
            invitation = invitation_data[:invitation]
            trainer_auth_body = invitation_data[:trainer_auth_body]

            {
                platform_token: invitation.platform_token,
                trainer_email: trainer_auth_body['email'],
                trainer_nick: trainer_auth_body['username']
            }
        end

        def serialize_full_invitations(invitations_data)
            invitations_data.map do |invitation_data|
                serialize_full_invitation(invitation_data)
            end
        end
        
    end

end