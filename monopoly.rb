require_relative './monopoly_class.rb' 

#create player 
player1 = Player.new("suki")
player2 = Player.new("brandon")
player3 = Player.new("richard")
player4 = Player.new("michael") 
player_list = [player1, player2, player3, player4]

#create property 
darwin = Property.new("Darwin", 100)
alice_spring = Property.new("Alice Spring", 120)
stanley = Property.new("Stanley", 140)
freycinet_national_park = Property.new("Freycinet National Park", 160)
hobart = Property.new("Hobart", 200)
margaret_river = Property.new("Margaret River", 220)
broome = Property.new("Broome", 240)
esperance = Property.new("Esperance", 260)
pilip_island = Property.new("Philip Island", 300)
melbourne = Property.new("Melbourne", 320)
canberra = Property.new("Canberra", 340)
questacon = Property.new("Questacon", 360)
kangaroo_island = Property.new("Kangaroo Island", 420)
gold_coast = Property.new("Gold Coast", 440)
white_sundays = Property.new("White Sundays", 460)
sydney = Property.new("Sydney", 500)

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

