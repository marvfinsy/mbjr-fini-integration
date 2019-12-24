class ServiceErrorSerializer
   include FastJsonapi::ObjectSerializer
   set_type :service_error

   attribute :status do | object |
      object.error_status
   end

   attribute :kind do | object |
      object.error_kind
   end

   attribute :message do | object |
      object.error_message
   end
end
