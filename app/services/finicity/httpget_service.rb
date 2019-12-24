class Finicity::HttpgetService < OurBaseService

   @@root_path = ENV['FINICITY_URL']
   @@port = 443
 
   def initialize(endpoint_path:, logit: 'no')
     @endpoint_path = endpoint_path
     @log_output = logit
   end
 
   def execute(access_token: nil) 
     uri = setup_uri
 
     http = ::Net::HTTP.new(uri.host, uri.port)
     http.use_ssl = true if uri.port == 443
     http.set_debug_output($stdout) if ['y', 'yes'].include?(@log_output.to_s.downcase)
 
     our_headers = {
       'Finicity-App-Key' => ENV['FINICITY_APP_KEY'],
       'Finicity-App-Token' => access_token,
       'Content-Type' => 'application/json', 
       'Accept' => 'application/json'
     }

     request = ::Net::HTTP::Get.new(
       uri.to_s,
       our_headers
     )
     resp = http.request(request)
     resp

   rescue URI::InvalidURIError => uri_e
     msg = uri_e.inspect + ' *** < URI not valid in ENV? > ***'
     Rails.logger.error(msg)
     raise uri_e
   rescue => e
     raise e
   end
 
   def setup_uri
     uri = URI.parse(@@root_path + @endpoint_path)
     uri.port = @@port
     uri
   end
 
 end
