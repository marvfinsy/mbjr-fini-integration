class MyBaseService
   # Std exception thrown by services.
   class MyServiceError < StandardError
   end

   attr_reader :id, :result_data
   attr_reader :error_status, :error_data, :error_kind, :error_message

   def initialize
      @id = nil
      @result_data = nil
      @error_data = nil
      @error_kind = nil
      @error_message = nil
   end

   def error_serializer_class
      ServiceErrorSerializer
   end
end
