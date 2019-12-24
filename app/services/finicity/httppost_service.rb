require 'net/http'

class Finicity::HttppostService < MyBaseService
   @@root_path = ENV['FINICITY_URL']
   @@port = 443

   def initialize(endpoint_path:, body: nil, logit: 'no')
      @endpoint_path = endpoint_path
      @body = body
      @log_output = logit
   end

   def execute(access_token: nil)
      uri = _setup_uri

      http = ::Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.port == 443
      http.set_debug_output($stdout) if ['y', 'yes'].include?(@log_output.to_s.downcase)

      our_headers = {
         'Finicity-App-Key' => ENV['FINICITY_APP_KEY'],
         'Content-Type' => 'application/json', 
         'Accept' => 'application/json'        
      }
      our_headers['Finicity-App-Token'] = access_token unless @access_token.nil?

      request = ::Net::HTTP::Post.new(
         uri.to_s,
         our_headers
      )
      request.body = @body.to_json if @body.present?

      resp = http.request(request)
      resp
      
   rescue URI::InvalidURIError => uri_e
      msg = uri_e.inspect + ' *** < URI not valid in ENV? > ***'
      Rails.logger.error(msg)
      raise uri_e
   rescue => e
      raise e
   end

   private

   def _setup_uri
      uri = URI.parse(@@root_path + @endpoint_path)
      uri.port = @@port
      uri
   end  
end
  