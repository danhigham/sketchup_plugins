require 'sinatra/base'

class BoardFeetServer < Sinatra::Base

  set :environment, :development
  set :views, settings.root + '/templates'

  def self.set_data(data)
    @@data = data
  end

  get '/model' do
    @entities = @@data
    erb :model
  end
end
