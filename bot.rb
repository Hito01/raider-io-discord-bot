require 'json'
require 'uri'

require 'discordrb'
require 'httparty'

bot = Discordrb::Commands::CommandBot.new token: ENV['BOT_TOKEN'], prefix: '!'

bot.command :rio do |event|
  args = event.message.content.split(' ')
  if args.size != 4
    event << 'Incorrect command. Please use the following syntax **!rio region realm character.**'
    event << 'Example: !rio eu Ysondre Thrall'
    return
  end

  uri = 'https://raider.io/api/v1/characters/profile?'
  uri << URI.encode_www_form(region: args[1], realm: args[2], name: args[3], fields: 'mythic_plus_scores_by_season:current')
  response = HTTParty.get(uri)
  if response.code != 200
    event << 'An error occurred while fetching the score.'
    return
  end

  json = JSON.parse(response.body)
  score = json['mythic_plus_scores_by_season'][0]['scores']['all']
  event << "#{args[3]} (#{args[2]}-#{args[1]}) raider.io score : **#{score}**"
end

bot.run

