class AnswerNotificationDatum < ApplicationRecord
    belongs_to :user

    # presence validations
    validates :time_tags, presence: true

    # length validations
    validates :time_tags, length: {maximum: 255}

    # custom validations
    validate :validate_number_of_answer_notification_data_on_user
    
    private
    
        def validate_number_of_answer_notification_data_on_user
            if self.new_record? && self.user != nil
                if self.user.answer_notification_data.count > 0
                    errors.add(:answer_notification_datum, "can be only one per user")
                end
            end
        end
end
