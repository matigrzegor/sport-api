module AccountLevel

    class Downgrade
    
        def initialize(management_token, extracted_user)
            @management_token = management_token
            @extracted_user = extracted_user
            new_account_level = @extracted_user.account_level
            @new_account_possibilities = AccountLevel::POSSIBILITIES[new_account_level]
        end

        def perform_downgrade
            remove_platform_invites
        end

        private
        
            def remove_platform_invites
                new_access_number = @new_account_possibilities[:platform_invites]

                utilized_number = 0

                attendant_memberships_array = []
                invitations_array = []
                pending_user_invitations_array = []

                @extracted_user.athlete_platforms.each do |platform|
                    attendant_memberships = platform.memberships.where(membership_status: 'attendant')
                    invitations = platform.invitations
                    pending_user_invitations = platform.pending_user_invitations

                    if attendant_memberships.count > 0
                        utilized_number += 1
                        attendant_memberships_array << attendant_memberships.first
                    end
    
                    if invitations.count > 0
                        utilized_number += 1
                        invitations_array << invitations.first
                    end

                    if pending_user_invitations.count > 0
                        utilized_number += 1
                        pending_user_invitations_array << pending_user_invitations.first
                    end
                end

                if utilized_number > new_access_number
                    number_of_platform_invites_to_delete = utilized_number - new_access_number

                    sorted_attendant_memberships_array = (attendant_memberships_array.sort {|x, y| y[:created_at] <=> x[:created_at]}).reverse
                    sorted_invitations_array = (invitations_array.sort {|x, y| y[:created_at] <=> x[:created_at]}).reverse
                    sorted_pending_user_invitations_array = (pending_user_invitations_array.sort {|x, y| y[:created_at] <=> x[:created_at]}).reverse
                    
                    first_fetch_number = number_of_platform_invites_to_delete - 1

                    pending_user_invitations_to_destroy = (sorted_pending_user_invitations_array.values_at(0..first_fetch_number)).compact

                    destroyed_platform_invites_number = 0

                    pending_user_invitations_to_destroy.each do |pending_user_invitation|
                        pending_user_invitation.destroy

                        destroyed_platform_invites_number += 1
                    end

                    if destroyed_platform_invites_number < number_of_platform_invites_to_delete
                        second_fetch_number = number_of_platform_invites_to_delete - destroyed_platform_invites_number - 1
                        
                        invitations_to_destroy = (sorted_invitations_array.values_at(0..second_fetch_number)).compact

                        invitations_to_remove_in_auth = []

                        invitations_to_destroy.each do |invitation|
                            invitations_to_remove_in_auth << invitation

                            invitation.destroy
    
                            destroyed_platform_invites_number += 1
                        end

                        if invitations_to_remove_in_auth.size > 0
                            invitations_to_remove_in_auth.each do |invitation|
                                invitation_process = InvitationProcess.new(@management_token, invitation.recipient_id)
    
                                if invitation_process.prepared_to_process == true
                                    invitation_process.destroy_invitation(invitation)
                                end
                            end
                        end

                        if destroyed_platform_invites_number < number_of_platform_invites_to_delete
                            third_fetch_number = number_of_platform_invites_to_delete - destroyed_platform_invites_number - 1
                        
                            attendant_memberships_to_destroy = (sorted_attendant_memberships_array.values_at(0..third_fetch_number)).compact

                            attendant_memberships_to_destroy.each do |attendant_membership|
                                attendant_membership.destroy
        
                                destroyed_platform_invites_number += 1
                            end

                            {status: :ok}
                        else
                            {status: :ok}
                        end
                    else
                        {status: :ok}
                    end
                else
                    {status: :ok}
                end
            end

    end

end
