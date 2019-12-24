class ApplicationController < ActionController::API

   def version
      render json: {version: '0.0.1', name: 'charlie brown - prototype'}, status: :ok
   end

   def renderjson(options={})
      netflix_opt = {is_collection: false}
      # Merge any netflix options passed with current default.
      if options[:netflix_opt].present?
        netflix_opt.merge!(options[:netflix_opt])
      end
      # If there any parameters being passed, set the proper hash key.
      # The netflix serializer will pass this key to our serializer. Giving
      # the serializer access to any object it contains.
      netflix_opt[:params] = options[:netflix_params] unless options[:netflix_params].blank?
      # Set the json to the output of our serializer.
      options[:json] = options[:serializerclass].new(
         options[:json],
         netflix_opt
      ).serialized_json
      # Now call std render().
      render(options)
    end
end
