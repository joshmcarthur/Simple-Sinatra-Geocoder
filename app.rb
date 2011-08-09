require 'bundler/setup'

APP_DIR = File.join(File.dirname(__FILE__), '../')

require 'sinatra/base'
require 'haml'
require 'csv'
require 'geokit'
require 'ruby-debug'

class App < Sinatra::Base
  
  set :public, "public"
  
  get '/' do
    haml :index
  end
  
  post '/geocode' do
    @geocoded_data = {}
    redirect '/' if params[:file_to_geocode][:tempfile].nil?
    CSV.parse(params[:file_to_geocode][:tempfile].read) do |row|
      if row.length > 1
        row[0] = row.join(' ')
      end
      data = Geokit::Geocoders::GoogleGeocoder.geocode row[0]
      @geocoded_data[data.full_address] = {:lat => data.lat, :long => data.lng}
    end
    haml :results
  end
end
