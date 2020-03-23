module AccountLevel
    
    ACCOUNTLEVELS = {
        'athlete_account' => 0,
        'trial_account' => 1,
        'plan_GwcFVgj6VPxnWU' => 1,
        'plan_GwcFPjnt2NeN0L' => 2,
        'plan_GwcFBpJA73AUHk' => 3,
        'plan_GwcEPVsVxRrk97' => 4,
        'plan_GwcEdhSBJ0VypG' => 5,
        'plan_GwcES0jsD2ILtH' => 6,
        'plan_GwcDD1KqoDhVkY' => 7,
        'plan_GwcCTwP6IJf2a3' => 8,
        'plan_GwcCYOMxLNMcfj' => 9,
        'plan_GwcCWVnk8BTthf' => 10,
        'plan_GwcBBzjiRdAhfk' => 11,
        'plan_GwcBb7xyVQZjma' => 12
    }
    
    def self.return_account_possibilities_hash(computational_number)
        if computational_number == 0
            @role_hash = {role: 'athlete'}
        else
            @role_hash = {role: 'trainer'}
        end

        platform_invites_number = computational_number
        athlete_platforms_number = computational_number * 2
        training_plans_number = computational_number * 10

        possibilities_hash = {:platform_invites => platform_invites_number,
                              :athlete_platforms => athlete_platforms_number,
                              :training_plans => training_plans_number}
        
        @role_hash.merge(possibilities_hash)
    end

    POSSIBILITIES = {
        :initial => {role: 'none'},
        0 =>  self.return_account_possibilities_hash(0),
        1 =>  self.return_account_possibilities_hash(6),
        2 =>  self.return_account_possibilities_hash(10),
        3 =>  self.return_account_possibilities_hash(14),
        4 =>  self.return_account_possibilities_hash(18),
        5 =>  self.return_account_possibilities_hash(22),
        6 =>  self.return_account_possibilities_hash(26),
        7 =>  self.return_account_possibilities_hash(30),
        8 =>  self.return_account_possibilities_hash(34),
        9 =>  self.return_account_possibilities_hash(38),
        10 => self.return_account_possibilities_hash(42),
        11 => self.return_account_possibilities_hash(46),
        12 => self.return_account_possibilities_hash(50)
    }

end