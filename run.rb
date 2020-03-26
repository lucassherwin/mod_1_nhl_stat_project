# arr = ["a", "b", "c", "d"]
# prompt = TTY::Prompt.new
# input = prompt.select("Select a team to search the roster") do |opt|
#     arr.each do |obj|
#         opt.choice obj
#     end
# end
#this works to make each joice an element in an array
#FOR FUTURE USE DO NOT FORGET
require 'pry'
require_relative './config/environment'
require 'rest-client'
require 'json'
require "tty-prompt"

def display_teams
    prompt = TTY::Prompt.new
    input = prompt.select("Select a team to search the roster") do |opt|
        opt.choice 'Anaheim Ducks'
        opt.choice 'Arizona Coyotes'
        opt.choice 'Boston Bruins'
        opt.choice 'Buffalo Sabres'
        opt.choice 'Calgary Flames'
        opt.choice 'Carolina Hurricanes'
        opt.choice 'Chicago Blackhawks'
        opt.choice 'Colorado Avalanche'
        opt.choice 'Columbus Blue Jackets'
        opt.choice 'Dallas Stars'
        opt.choice 'Detroit Red Wings'
        opt.choice 'Edmonton Oilers'
        opt.choice 'Florida Panthers'
        opt.choice 'Los Angeles Kings'
        opt.choice 'Minnesota Wild'
        opt.choice 'Montreal Canadiens'
        opt.choice 'Nashville Predators'
        opt.choice 'New Jersey Devils'
        opt.choice 'New York Islanders'
        opt.choice 'New York Rangers'
        opt.choice 'Ottawa Senators'
        opt.choice 'Philadelphia Flyers'
        opt.choice 'Pittsburgh Penguins'
        opt.choice 'St Louis Blues'
        opt.choice 'San Jose Sharks'
        opt.choice 'Tampa Bay Lightning'
        opt.choice 'Toronto Maple Leafs' #leafs suck
        opt.choice 'Vancouver Canucks'
        opt.choice 'Vegas Golden Knights'
        opt.choice 'Washington Capitals'
        opt.choice 'Winnipeg Jets'
    end
    input
end

def get_team_id(input)
    if(input == "Anaheim Ducks")
        team_id = 24
    elsif(input == "Arizona Coyotes")
        team_id = 53
    elsif(input == "Boston Bruins")
        team_id = 6
    elsif(input == "Buffalo Sabres")
        team_id = 7
    elsif(input == "Calgary Flames")
        team_id = 20
    elsif(input == "Carolina Hurricanes")
        team_id = 12
    elsif(input == "Chicago Blackhawks")
        team_id = 16
    elsif(input == "Colorado Avalanche")
        team_id = 21
    elsif(input == "Columbus Blue Jackets")
        team_id = 29
    elsif(input == "Dallas Stars")
        team_id = 25
    elsif(input == "Detroit Red Wings")
        team_id = 17
    elsif(input == "Edmonton Oilers")
        team_id = 22
    elsif(input == "Florida Panthers")
        team_id = 13
    elsif(input == "Los Angeles Kings")
        team_id = 26
    elsif(input == "Minnesota Wild")
        team_id = 30
    elsif(input == "Montreal Canadiens")
        team_id = 8
    elsif(input == "Nashville Predators")
        team_id = 18
    elsif(input == "New Jersey Devils")
        team_id = 1
    elsif(input == "New York Islanders")
        team_id = 2
    elsif(input == "New York Rangers")
        team_id = 3
    elsif(input == "Ottawa Senators")
        team_id = 9
    elsif(input == "Philadelphia Flyers")
        team_id = 4
    elsif(input == "Pittsburgh Penguins")
        team_id = 5
    elsif(input == "St Louis Blues")
        team_id = 19
    elsif(input == "San Jose Sharks")
        team_id = 28
    elsif(input == "Tampa Bay Lightning")
        team_id = 14
    elsif(input == "Toronto Maple Leafs")
        team_id = 10
    elsif(input == "Vancouver Canucks")
        team_id = 23
    elsif(input == "Vegas Golden Knights")
        team_id = 54
    elsif(input == "Washington Capitals")
        team_id = 15
    elsif(input == "Winnipeg Jets")
        team_id = 52
    end
    team_id
end

def search_player(player_id, user)
    unparsed_data = RestClient.get("https://statsapi.web.nhl.com/api/v1/people/#{player_id}")
    parsed_data = JSON.parse(unparsed_data)

    puts "Name: #{parsed_data["people"][0]["fullName"]}"
    puts "Birth date: #{parsed_data["people"][0]["birthDate"]}"
    puts "Height: #{parsed_data["people"][0]["height"]}"
    puts "Weight: #{parsed_data["people"][0]["weight"]}"
    puts "Position: #{parsed_data["people"][0]["primaryPosition"]["name"]}"

    main_prompt(user)
end

def serach_by_team(user)
   choice = display_teams
   team_id = get_team_id(choice)

   prompt = TTY::Prompt.new
   input = prompt.select("Please select an option to display") do |opt|
    opt.choice 'Roster'
    opt.choice 'Team Stats'
    opt.choice 'Rankings'
   end
   
   #serach team by id
   #display stats
   unparsed_data = RestClient.get("https://statsapi.web.nhl.com/api/v1/teams/#{team_id}/stats")
   parsed_data = JSON.parse(unparsed_data)

   if(input == "Roster")
    get_roster(team_id)
   elsif(input == "Team Stats")
    puts "Wins: #{parsed_data["stats"][0]["splits"][0]["stat"]["wins"]}"
    puts "Losses: #{parsed_data["stats"][0]["splits"][0]["stat"]["losses"]}"
    puts "Points: #{parsed_data["stats"][0]["splits"][0]["stat"]["pts"]}"
    puts "Point Percentage: #{parsed_data["stats"][0]["splits"][0]["stat"]["ptPctg"]}"
    puts "Goals Per Game: #{parsed_data["stats"][0]["splits"][0]["stat"]["goalsPerGame"]}"
   else
    puts "Wins: #{parsed_data["stats"][1]["splits"][0]["stat"]["wins"]}"
    puts "Losses: #{parsed_data["stats"][1]["splits"][0]["stat"]["losses"]}"
    puts "Points: #{parsed_data["stats"][1]["splits"][0]["stat"]["pts"]}"
    puts "Point Percentage: #{parsed_data["stats"][1]["splits"][0]["stat"]["ptPctg"]}"
    puts "Goals Per Game: #{parsed_data["stats"][1]["splits"][0]["stat"]["goalsPerGame"]}"
   end

   main_prompt(user)
end

def search_by_draft_year(user)
    puts "Enter a draft year to search: "
    input = gets.chomp

    unparsed_data = RestClient.get("https://statsapi.web.nhl.com/api/v1/draft/#{input}")
    parsed_data = JSON.parse(unparsed_data)

    parsed_data["drafts"][0]["rounds"][0]["picks"].each do |obj|
        puts "Name: #{obj["prospect"]["fullName"]}      Pick Overall: #{obj["pickOverall"]}     Team: #{obj["team"]["name"]}"
    end

    main_prompt(user)
end

def get_roster(team_id)
    unparsed_data = RestClient.get("https://statsapi.web.nhl.com/api/v1/teams/#{team_id}/roster")
    parsed_data = JSON.parse(unparsed_data)
    
    roster_arr = parsed_data["roster"]
    roster_arr.each do |obj|
        puts "Name: #{obj["person"]["fullName"]} ID: #{obj["person"]["id"]}"
    end
end

def search_by_player(user)
    #first have user select the team the player is on
    #with this api there is no way to serach just by player name
    
    input = display_teams
    #display roster (name and id) for chosen team
    #prompt user to enter id of desired player
    team_id = get_team_id(input)

    get_roster(team_id)

    puts "Enter the ID of a player to search:"
    p_id = gets.chomp
    search_player(p_id, user)
end

def create_user
    #user name
    puts "Please enter your name:"
    name = gets.chomp

    # puts "Please create a password"
    prompt = TTY::Prompt.new
    password = prompt.mask("Please create a password:")

    user = User.find_or_create_by(name: name, password: password)
    user
end

def add_player(user)
    #first create user
    # user = create_user
    current_user = user
    #adds searches and adds player to team
    #prompts to add another player
    puts "Please serach for a player to add to the team:"
    team = display_teams
    team_id = get_team_id(team)
    get_roster(team_id)

    puts "Please enter ID of player to add:"
    player_id = gets.chomp
    # search_player(input)
    #search for player
    unparsed_data = RestClient.get("https://statsapi.web.nhl.com/api/v1/people/#{player_id}")
    parsed_data = JSON.parse(unparsed_data)
    #save player to DB
    player_name = parsed_data["people"][0]["fullName"]
    player = Player.find_or_create_by(user_id: current_user.id, team_id: team, player_name: player_name)

    #present additional options
    additional_user_team_options(current_user)
end

def create_team(user)
    #allow user to create a team with a name and a location
    #save player info (fullName, goals, assists)
    current_user = user
    #first create a user
    # user = create_user
    #get input
    puts "Please enter a team name:"
    name_input = gets.chomp

    puts "Please enter a location for your team:"
    city_input = gets.chomp

    #save input to table
    team = Team.find_or_create_by(name: name_input, location: city_input)

    #add players to team
    # player = add_player
    add_player(current_user)
end

def delete_last_player(user)
    # last_player = Player.select {|obj| obj.id == }
    puts "delete last player"
    
    current_user = user
    
    last_player = Player.select {|obj| obj.user_id == user.id}
    # binding.pry
    last_player.last.delete
    additional_user_team_options(current_user)
end

def show_team(user)
    puts "Show team"
    current_user = user
    
    current_team = Player.select {|obj| obj.user_id == current_user.id}
    current_team.each {|obj| puts obj.player_name}
    # binding.pry
    #return user to additonal team option
    additional_user_team_options(current_user)
end

def additional_user_team_options(user)
    current_user = user

    prompt = TTY::Prompt.new
    input = prompt.select("Please choose an option") do |opt|
        opt.choice 'Show Team'
        opt.choice 'Add Player'
        opt.choice 'Remove Player'
        opt.choice 'Main Menu'
    end

    if(input == "Show Team")
        show_team(current_user)
    elsif(input == "Add Player")
        add_player(current_user)
    elsif(input == "Remove Player")
        delete_last_player(current_user)
    else
        main_prompt(current_user)
    end
end

def main_prompt(user)
    prompt = TTY::Prompt.new
    input = prompt.select("Please choose an option") do |opt|
        opt.choice 'Search Team'
        opt.choice 'Search Draft Year'
        opt.choice 'Search Player'
        opt.choice 'Create Team'
    end

    current_user = user
    main_options(current_user, input)
end

def main_options(user, input)
    current_user = user

    if(input == "Search Player")
        search_by_player(current_user)
    elsif(input == "Search Team")
        serach_by_team(current_user)
    elsif(input == "Search Draft Year")
        search_by_draft_year(current_user)
    elsif(input == "Create Team")
        create_team(current_user)
    end
end
def main_menu

    puts "Welcome please create a user to start"
    user = create_user

    input = main_prompt(user)

    # current_user = user

    main_options(user, input)
end

def run
    main_menu
end



run
