class Api::FiniRegistrationsController < ApplicationController
   def create
      body = request.body.read
      return render json: {}, status: :bad_request unless body.present?
      # Parse body string to get json.
      json_body = JSON.parse(body)
      service = _create_fini_registr_service(registr_data: json_body['data'])
      result_data = service.execute
      unless result_data.nil?
         return renderjson serializerclass: _fini_registr_serializer_class, 
            json: result_data,
            status: :created
      end
      # Error nil returned, error occurred.
      renderjson serializerclass: service.error_serializer_class, 
                                    json: service, 
                                    status: :conflict
   end

   private

   def _fini_registr_serializer_class
      FiniRegistrationSerializer
   end

   def _create_fini_registr_service(registr_data:)
      Finicity::CreateFiniRegistrationService.new(registr_data: registr_data)
   end
  end
