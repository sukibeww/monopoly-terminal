require_relative './monopoly_class.rb' 
require 'tty-box' 

#create player 
player1 = Player.new("suki")
player2 = Player.new("brandon")
player3 = Player.new("richard")
player4 = Player.new("michael") 
player_list = [player1, player2, player3, player4]

#create property 
darwin = Property.new("Darwin", 100, "DRW")
alice_spring = Property.new("Alice Spring", 120, "ASP")
stanley = Property.new("Stanley", 140, "DRW")
freycinet_national_park = Property.new("Freycinet National Park", 160, "FNP")
hobart = Property.new("Hobart", 200, "HBT")
margaret_river = Property.new("Margaret River", 220, "MGR")
broome = Property.new("Broome", 240, "BRM")
esperance = Property.new("Esperance", 260, "ESP")
pilip_island = Property.new("Philip Island", 300, "PLI")
melbourne = Property.new("Melbourne", 320, "MLB")
canberra = Property.new("Canberra", 340, "CNB")
questacon = Property.new("Questacon", 360, "QTC")
kangaroo_island = Property.new("Kangaroo Island", 420, "KGR")
gold_coast = Property.new("Gold Coast", 440, "GCS")
white_sundays = Property.new("White Sundays", 460, "WHS")
sydney = Property.new("Sydney", 500, "SYD")

#create chance and community class object 
chance = Chance.new() 
community_chest = CommunityChest.new() 

#create corner classes
start = Start.new() 
jail = Jail.new() 
free_parking = FreeParking.new() 

#map 
map = [
    start,
    darwin,
    alice_spring,
    chance,
    stanley,
    freycinet_national_park,
    jail,
    hobart,
    margaret_river, 
    community_chest, 
    broome,
    esperance,
    free_parking,
    pilip_island,
    melbourne,
    chance, 
    canberra,
    questacon,
    jail,
    kangaroo_island,
    gold_coast,
    community_chest,
    white_sundays,
    sydney
]

def display_map(map) 
    map_array = [] 
    map.each do |tile| 
        map_array.push(display_tile(tile))
    end 
    map_output = ""
    map_array.each do |box|
        map_output << box.to_s
    end 
end 

def display_tile(tile)
    #determine the type of the object 
    if(tile.is_a?(Property))
        box = TTY::Box.frame(
            width: 18,
            height: 6,
            align: :center) do
                """#{tile.id}
tier:#{tile.tier}
owner: P1
#{tile.in?()}
                """
            end 
        print box
    elsif tile.is_a?(Chance)
        box = TTY::Box.frame(
            width: 18,
            height: 6,
            padding: 1,
            align: :center) do
                """Chance
#{tile.in?()}"""
            end 
        print box
    elsif tile.is_a?(CommunityChest)
        box = TTY::Box.frame(
            width: 18,
            height: 6,
            padding: 1,
            align: :center) do
                """Community 
Chest
#{tile.in?()}"""
            end 
        print box
    elsif tile.is_a?(Start)
        box = TTY::Box.frame(
            width: 18,
            height: 6,
            padding: 1,
            align: :center) do
                """Start
#{tile.in?()}"""
            end 
        print box
    elsif tile.is_a?(Jail)
        box = TTY::Box.frame(
            width: 18,
            height: 6,
            padding: 1,
            align: :center) do
                """Jail
#{tile.in?()}"""
            end 
        print box
    end
    return box 
end 

def game(player_list, map) 
    game_boolean = true 
    map[0].player_in << player_list
    player_list.each do |player|
        puts "#{player.name} turn"
        map[player.location].move_out(player) 
        player_step = player.toss_dice() 
        puts "#{player.name} landed on a #{map[player.location].class} , #{player.location}"
        map[player.location].move_in(player)
    end 
    display_map(map)
end 

game(player_list, map) 