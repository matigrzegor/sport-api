class PlatformMessage < ApplicationRecord
    belongs_to :platform_chat

    # presence validations
    validates :user_auth_sub, :message_date, :message_text, :message_read, presence: true

    # length validations
    validates :message_text, length: {maximum: 30000}


    def self.fetch_messages(fetch_number)
        number_to_fetch = fetch_number * 20
        
        self.last(number_to_fetch)[number_to_fetch - 20, 20]
    end

end
