require 'pit'
require 'spaceship'

class TunesService
  attr_reader :client
  def create_client(team)
    adp_login = ENV['ADP_LOGIN']
    if adp_login
      a = adp.split(':', 2)
      adp_login_user = a[0]
      adp_login_password = a[1]
    else
      adp_login_user = ENV['ADP_LOGIN_USER']
      adp_login_password = ENV['ADP_LOGIN_PASSWORD']
    end
    
    if adp_login_user == nil || adp_login_user == '' || adp_login_password == nil || adp_login_password == ''
      config = Pit.get('developer.apple.com', :require => {
        'email' => '',
        'password' => ''
      })
      adp_login_user = config['email']
      adp_login_password = config['password']
    end
    
    @client = Spaceship::Tunes.login(adp_login_user, adp_login_password)
    
    if team
      teams = @client.teams
      selected = teams.find { |t|
         t["name"].include?(team)
      }
      @client.team_id = selected["providerId"].to_s
    else
      Spaceship::Tunes.select_team
    end
    return @client
  end
end
