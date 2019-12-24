class Finicity::CreateFiniRegistrationService < MyBaseService

   def initialize(registr_data:)
      @registr_data = registr_data
   end

   def execute
      record_data = @registr_data['attributes']
      if record_data.nil?
         Rails.logger.error('CreateFiniRegistrationService> No registration record in parameters. Skipping...')
         @error_kind = 'CREATE_REGISTRATION_FAILED'
         @error_message = 'No registration record in parameters. Skipping...'
         return nil
      end
      registr_rec = FinicityRegistration.new(
         uid: record_data['uid'],
         profile_id: record_data['profile_id'],
         fini_customer_id: record_data['fini_customer_id'] )
   
      FinicityRegistration.transaction do
         registr_rec.save!
      end
      @result_data = registr_rec
      return @result_data
   rescue => e
      @error_kind = 'CREATE_REGISTRATION_FAILED'
      @error_message = e.message
      return nil
   end
end
