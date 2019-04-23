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
pass_jail = Jail.new() 
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
    pass_jail,
    kangaroo_island,
    gold_coast,
    community_chest,
    white_sundays,
    sydney
]

def display_map(map) 
    map_array = [] 
    map_output = ""
    empty_box = TTY::Box.frame(
        width: 18,
        height: 6,
        align: :center,
        border: {
            type: :thick, 
            top: false, 
            bottom: false,
            right: false,
            left: false
        })
    map.each do |tile| 
        map_array.push(display_tile(tile))
    end 

    #line one 
    line_one_map = concatenate_map(map_array[0] , map_array[1])
    counter = 2 
    while(counter <= 6 )
        line_one_map = concatenate_map(line_one_map, map_array[counter])
        counter += 1 
    end 

    #line two 
    counter = 2
    line_two_map = concatenate_map(map_array[23], empty_box.to_s)
    while(counter <= 6) 
        if(counter == 6 )
            line_two_map = concatenate_map(line_two_map, map_array[7])
        else
            line_two_map =concatenate_map(line_two_map, empty_box) 
        end 
        counter += 1
    end 

    #line three 
    counter = 2
    line_three_map = concatenate_map(map_array[22], empty_box.to_s)
    while(counter <= 6) 
        if(counter == 6 )
            line_three_map = concatenate_map(line_three_map, map_array[8])
        else
            line_three_map =concatenate_map(line_three_map, empty_box) 
        end 
        counter += 1
    end 

    #line four 
    counter = 2
    line_four_map = concatenate_map(map_array[21], empty_box.to_s)
    while(counter <= 6) 
        if(counter == 6 )
            line_four_map = concatenate_map(line_four_map, map_array[9])
        else
            line_four_map =concatenate_map(line_four_map, empty_box) 
        end 
        counter += 1
    end 

    counter = 2
    line_five_map = concatenate_map(map_array[20], empty_box.to_s)
    while(counter <= 6) 
        if(counter == 6 )
            line_five_map = concatenate_map(line_five_map, map_array[10])
        else
            line_five_map =concatenate_map(line_five_map, empty_box) 
        end 
        counter += 1
    end 

    #line six
    counter = 2
    line_six_map = concatenate_map(map_array[19], empty_box.to_s)
    while(counter <= 6) 
        if(counter == 6 )
            line_six_map = concatenate_map(line_six_map, map_array[9])
        else
            line_six_map =concatenate_map(line_six_map, empty_box) 
        end 
        counter += 1
    end 

    #line seven 
    line_seven_map = concatenate_map(map_array[18] , map_array[17])
    counter = 16
    while(counter >= 12)
        line_seven_map = concatenate_map(line_seven_map, map_array[counter])
        counter -= 1 
    end 
    print line_one_map
    print line_two_map
    print line_three_map
    print line_four_map
    print line_five_map
    print line_six_map
    print line_seven_map 
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
    elsif tile.is_a?(Chance)
        box = TTY::Box.frame(
            width: 18,
            height: 6,
            padding: 1,
            align: :center) do
                """Chance
#{tile.in?()}"""
            end 
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
    elsif tile.is_a?(Start)
        box = TTY::Box.frame(
            width: 18,
            height: 6,
            padding: 1,
            align: :center) do
                """Start
#{tile.in?()}"""
            end 
    elsif tile.is_a?(Jail)
        box = TTY::Box.frame(
            width: 18,
            height: 6,
            padding: 1,
            align: :center) do
                """Jail
#{tile.in?()}"""
            end 
elsif tile.is_a?(FreeParking)
    box = TTY::Box.frame(
        width: 18,
        height: 6,
        padding: 1,
        align: :center) do
            """Free
Parking
#{tile.in?()}"""
        end 
    end 
    return box.to_s 
end 

def tile_reader(tile) 
    if(tile.is_a? Property)

    elsif (tile.is_a? Start)

    elsif (tile.is_a? Chance)

    elsif (tile.is_a? CommunityChest)

    elsif (tile.is_a? Jail)

    elsif (tile.is_a? FreeParking) 

    end 
end 

require 'pry'
def game(player_list, map) 
    map[0].player_in = player_list
    puts map[6].class
    counter = 0
    while(counter <= 3)
        puts "#{player_list[0].name} turn"
        origin = player_list[0].location
        player_list[0].toss_dice() 
        destination = player_list[0].location 
        map[destination].move_in(player_list[0])
        after_move = map[origin].move_out(player_list[0])
        counter += 1 
    end 
    display_map(map)
end 

def concatenate_map(current_display, next_tile)
    current_display_lines = current_display.lines 
    next_tile_lines = next_tile.lines
    return current_display_lines.each_with_object('') { |line, str| str << line.chomp << next_tile_lines.shift }
end 

game(player_list, map) 
