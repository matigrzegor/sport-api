module Api::V1

    module CalendarCommentSerializer

        def serialize_calendar_comment(calendar_comment)
            {
                id: calendar_comment.id,
                comment_user: calendar_comment.comment_user,
                comment_data: calendar_comment.comment_data,
                comment_body: calendar_comment.comment_body,
                comment_day: calendar_comment.comment_day,
                comment_user_role: calendar_comment.comment_user_role
            }
        end
        
        def serialize_calendar_comments(calendar_comments)
            calendar_comments.map do |calendar_comment|
                serialize_calendar_comment(calendar_comment)
            end
        end

    end

end