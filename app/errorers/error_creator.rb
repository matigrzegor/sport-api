module Errorer

    class ErrorCreator
        
        def initialize(controller = '')
            @controller = controller
        end

        def create_error(code, reference_number)
            main_hash = Errorer::MAIN_ERROR_PARTS[code]
            reference_code_hash = return_reference_code_hash(reference_number)

            error_hash = main_hash.merge(reference_code_hash)
            
            return_full_json(error_hash)
        end

        def create_specific_error(error_name)
            error_hash = Errorer::SPECIFIC_ERRORS[error_name]
            
            return_full_json(error_hash)
        end

        private

            def return_reference_code_hash(reference_number)
                reference_code = Errorer::REFERENCE_CODE_BASES[@controller] + reference_number
                
                {reference_code: reference_code}
            end

            def return_full_json(error_hash)
                {
                    error: error_hash
                }
            end
    end

end