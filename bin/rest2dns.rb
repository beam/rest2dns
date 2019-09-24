# frozen_string_literal: true

require 'sinatra'
require 'json'

require_relative '../lib/syncdns.rb'

before do
  content_type 'application/json'
end

helpers do
  def json_params
    JSON.parse(request.body.read)
  rescue StandardError => err
    $log.error(err)
    halt 400, { message: 'Invalid JSON' }.to_json
  end
end

get '/' do
  "Rest2DNS remote API\n"
end

# get zones
get '/zones' do
  { 'zones' => SyncDNS.list_zones }.to_json
end

# setup zone
post '/zones' do
  data = json_params
  result = SyncDNS.check_zone(data['zones'].first, data['content'])
  if result.last.success?
    result = SyncDNS.setup_zone(data['zones'], data['content'])
  end
  halt (result.last.success? ? 200 : 503), result.first.to_json
end

# delete zone
delete '/zones' do
  data = json_params
  SyncDNS.destroy_zone(data['zones'])
  # halt (result.last.success? ? 200 : 503), result.first.to_json
  halt 200
end

# check zone
post '/zones/check' do
  data = json_params
  result = SyncDNS.check_zone('syncdns-check.tld', data['content'])
  halt (result.last.success? ? 200 : 503), result.first.to_json
end
