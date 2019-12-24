class Finicity::HttpcallWAccessTokService < MyBaseService
   @@log_output = 'yes'
   
   def initialize(http_req_obj:)
     @http_req_obj = http_req_obj
   end
 
   def execute_request
      # return caller's request obj.
      @result = @http_req_obj

      for ct in 1..2 do
         access_tok_rec = _get_customer_access_token_from_db
         if access_tok_rec.nil?
            @error_message = 'Access Token record not found in DB'
            return nil
         end

         @http_req_obj.run_http_request(access_token: access_tok_rec.access_token)
         # If some kind of http error or no response body, nothing we can do.
         return {result: @result} unless @http_req_obj.response_body.present?
         return {result: @result} if @http_req_obj.response_body['code'].nil?
         # Have a response body. Check it's status code in that response_body.
         return {result: @result} if @http_req_obj.response_body['code'].to_s != '10023' && @http_req_obj.response_body['code'].to_s != '10022'
         # We got refresh error.
         if ct > 1
            # We refreshed access token once. Why did we get refresh error again?
            @error_status = @requester.http_status
            @error_message = 'Refresh was not successful:' + "#{@http_req_obj.response_body}"
            return nil
         end

         unless _update_access_token
            @error_message = 'Access Token refresh attempted but was not successful.'
            return nil
         end
         # Let's try again.
         # End of loop.
      end
      # Should not get here...
      raise RuntimeError.new 'Have access token loop error. outside of loop.'
   end

   private

   def _get_customer_access_token_from_db
     AccessToken.first
   end
 
   def _update_access_token
      service = _get_post_req_serv
      service.execute
   end
  
   def _get_access_token_service
      Finicity::GetAccessTokenService.new
   end

   def _get_post_req_serv(endpoint_path:, body: nil)
     Finicity::HttppostService.new(endpoint_path: endpoint_path, body: body)
   end 
end
