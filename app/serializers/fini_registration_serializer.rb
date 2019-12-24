class FiniRegistrationSerializer
   include FastJsonapi::ObjectSerializer
   set_type :fini_registration

   attributes  :id,
               :uid,
               :profile_id,
               :fini_customer_id
end
