require 'odesk/api'

Odesk::API_CLIENT = Odesk::Api::Client.new(Odesk::Api::Config.new({
  "consumer_key"    => Rails.application.secrets.api["odesk"]["consumer_key"],
  "consumer_secret" => Rails.application.secrets.api["odesk"]["consumer_secret"],
  "access_token"    => Rails.application.secrets.api["odesk"]["access_token"],
  "access_secret"   => Rails.application.secrets.api["odesk"]["access_secret"]
}))

module Odesk
  def self.router_for *args
    path = args.join "/"
    require "odesk/api/routers/#{path}"

    klass = Odesk::Api::Routers.const_get("#{path.camelize}") rescue nil
    klass = Odesk::Api::Routers.const_get("#{path.camelize.pluralize}") unless klass

    klass.new API_CLIENT
  end
end
