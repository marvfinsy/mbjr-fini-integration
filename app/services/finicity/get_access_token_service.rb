class Finicity::GetAccessTokenService < MyBaseService
   @@access_token_path = ENV['FINICITY_ACCESS_TOKEN_ENDPOINT_PATH']
   @@log_output = 'yes'

   def execute
      result = _get_finicity_access_token
      if result[:token].nil?
         @result_data = false
         return @result_data
      end
      # Save access token.
      cur_rec = AccessToken.first
      if cur_rec.nil?
         _create_new_access_token_in_db(access_token: result[:token])
      else
         _update_access_token_in_db(cur_access_tok_rec: cur_rec, new_access_token: result[:token])      
      end
      # I do not return token. Just indicate success.
      @result_data = true
      return @result_data
   end

   private

   def _get_finicity_access_token
      body = {
         partnerId: ENV['FINICITY_PARTNER_ID'],
         partnerSecret: ENV['FINICITY_PARTNER_SECRET']
      }
      # Call finicity.
      service = _post_req_serv(endpoint_path: @@access_token_path, body: body)
      response = service.execute
      return {status: response.code } unless response.body.present?

      resp_body = JSON.parse(response.body)
      if response.code == "200"
         return {status: response.code, token: resp_body['token']}
      end
      return {status: response.code, error_data: resp_body}
   end

   def _update_access_token_in_db(cur_access_tok_rec:, new_access_token:)    
      cur_access_tok_rec.update_attributes(
        {access_token: new_access_token, last_refresh_time: Time.now.getutc} )
      return cur_access_tok_rec
    end
  
    def _create_new_access_token_in_db(access_token:)
      return AccessToken.create(
        access_token: access_token,
        last_refresh_time: Time.now.getutc)
    end
  
   def _post_req_serv(endpoint_path:, body: nil)
      Finicity::HttppostService.new(endpoint_path: endpoint_path, body: body, logit: @@log_output)
    end  
end
