
class Player
attr_accessor :name, :money, :location :jail_status
    def initialize(name)
        @name = name
        @money = 4000
        @jail_status = false
        # @property = {
        #     melbourne: melbourne
        # }
        @location = 0
    end
    def toss_dice
        step = rand(1..6)
        @location = @location + step
        if(@location > 23)
            @location -= 23
            lap()
        end
    end

    def lap()
        @money += 1000
    end

    def buy_property(property,map)
        if map[@location] = property and (@money >= property.buy_cost)
            property_name_sym = property.name.to_sym
            @property.merge!("#{property_name_sym}": property)
        else
            puts "Not enought money"
        end
    end

    def put_in_jail?(player)
        if player.location = 6
            player.jail_status = true
            player.jail_time = 2
            @player_in_jail.merge!(player.name.to_sym(), player)
        elsif player.location = 18
            puts "passing by the jail"
        end
    end
end

#  def to_s(player,location,map)
#         "location:" + map[player.location].name
#     end


# class Player
#     attr_reader :name
#     attr_accessor :money, :property, :jail_status
#     def initialize(name)
#         @name = name
#         @money = 4000
#         @property = {}
#         @jail_status = false
#         @jail_time = 0
#     end

# def bribe
#     if(@money > 300 && @jail_time >= 1)
#         puts "Do you want to bribe your way out of jail? ($300)"
#         puts "1.Yes"
#         puts "2.No"
#         player_input = gets.strip
#         case player_input
#         when "1"
#             @money -= 300
#             @jail_time = 0
#             @jail_status = false
#             puts "You are free!"
#         when "2"
#             puts "You lose a turn"
#             @jail_time -= 1
#         end
#     end
# end



#     def rent(player)
#         if(player.money >= @rent)
#             player.money -= @rent
#         else
#             puts "Not enought money"
#         end
#         return player
#     end

# end

class Chance

    def initialize ()
        @random_chance = 0
    end

    def draw()
        @random_chance = 2
    end

    def read(player)

        case draw()
        when 1
            chance_1(player)
        when 2
            chance_2(player)
        when 3
            chance_3(player)
        when 4
            chance_4(player)
        when 5
            chance_5(player)
        end
    end

    def chance_1(player)
        puts "Jail Switch "
        if jail_status == false
        jail_status = true
        puts " You are in jail now !"
        else
        jail_status = false
        puts " Congratulations, you get bailed !"
        end
    end

    def chance_2(player)
        puts " Move forward up to 5 spaces"
        player.location = player.location + 5

    end

    def chance_3(player)
        puts "Make general repairs on all your property–For each house pay $25"
        player.money -= player.property.length *25
    end

    def chance_4(player)
        puts "put into jail"
        jail.status = false

    end

    def chance_5(player)
        puts "pay owner a total ten times the amount of rent"
        player.money -= player.money - 10 * rent
    end
end


class CommunityChest
    def initialize
        @random_community_chest
    end

    def draw()
        @random_community_chest = rand(1..2)
    end

    def read(player)
        @random_community_chest = draw()
        case @random_community_chest
        when 1
            community_chest_1(player)
        when 2
            community_chest_2(player)
        when 3
            community_chest_3(player)
        when 4
            community_chest_4(player)
        when 5
            community_chest_5(player)
        end
    end


    def community_chest_1(player)
        puts " Bank pays you dividend of $50"
        player.money += 50
    end

    def community_chest_2(player)
        puts "Doctor's fees – Pay $200"
        player.money -= 200
    end

    def community_chest_3(player)
        puts "It is your birthday Collect $10 from each player"
        player.money += 4* 10
    end

    def community_chest_4(player)
        puts "Pay School Fees of $120"
        player.money -= 120
    end

    def community_chest_5(player)
        puts "You are assessed for street repairs – $40 per house, $115 per hotel"
         #???????????????????????????
    end
end


class Property
    attr_reader :name, :id
    attr_accessor :rent, :buy_cost, :owner, :tier
    def initialize(name, buy_cost, id)
        @name = name
        @id = id
        @rent = buy_cost/2
        @buy_cost = buy_cost
        @owner
        @tier = 1
    end

    def upgrade(player)
        upgrade_cost = @buy_cost
        if(@tier <= 3 && player.money >= upgrade_cost)
            player.money = player.money - upgrade_cost
            @rent = @rent * 2
            @buy_cost += @buy_cost
            @tier += 1
        else
            puts "Not enough money"
        end
    end
end

class Start
    def lap(player)
        player.money += 1000
        return player
    end
end

class Jail

    def initialize
        @player_in_jail = {}
    end
end
in_jail = Jail.new
pass_jail = Jail.new
class FreeParking
    def free_parking(player, player_position)
        #move player to the desired position
    end
end




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

chance = Chance.new()
community_chest = CommunityChest.new()

#create corner classes
start = Start.new()
jail = Jail.new()
free_parking = FreeParking.new()


map = [
    start,
    darwin,
    alice_spring,
    chance,
    stanley,
    freycinet_national_park,
    in_jail,
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
player1 = Player.new("suki")
player2 = Player.new("brandon")
player3 = Player.new("richard")
player4 = Player.new("michael")
puts player1.location
puts map[player1.location]
puts player1.money
player1.toss_dice
puts player1.location
puts map[player1.location]
puts player1.money


#  puts chance.draw
#  chance.read(player1)
#  puts player1.location
#  puts map[player1.location]


# player1.toss_dice
# puts player1.location
# puts map[player1.location]



# class Property
#     def initialize(name, rent, buy_cost)
#         @name = name
#         @rent = rent
#         @buy_cost = buy_cost
#     end

#     def upgrade(player)
#         upgrade_cost = buy_cost * 2
#         if(player.money >= upgrade_cost)
#             player.money = player.money - upgrade_cost
#             @rent = @rent * 2
#             @buy_cost += @buy_cost
#         else
#             puts "Not enought money"
#         end
#     end

#     def rent(player)
#         if(player.money >= @rent)
#             player.money -= @rent
#         else
#             puts "Not enough money"
#         end
#         return player
#     end
# end




# chance_array= [chance_1,chance_2,chance_3,chance_4,chance_5]
# foturne_array = [chest_1,chest_2,chest_3,chest_4,chest_5]
# chance_1 = {}
# chance_2 = {}
# chance_3 = {}
# chance_4 = {}
# chance_5 = {}
# chest_1 = {}
# chest_2 = {}
# chest_3 = {}
# chest_4 = {}
# chest_5 = {}



# Bank pays you dividend of $50
# Get Out of Jail Free
# Go Back 3 Spaces
# Go to Jail–Go directly to Jail–Do not pass Go, do not collect $200
# Make general repairs on all your property–For each house pay $25–For each hotel $100
# Pay poor tax of $15
# Take a trip to Reading Railroad–If you pass Go, collect $200
# Take a walk on the Boardwalk–Advance token to Boardwalk
# You have been elected Chairman of the Board–Pay each player $50
# Your building and loan matures—Collect $150
# You have won a crossword competition—Collect $100

# chest :
# Bank error in your favor – collect $75
# Doctor's fees – Pay $50
# Get out of jail free – this card may be kept until needed, or sold
# Go to jail – go directly to jail – Do not pass Go, do not collect $200
# It is your birthday Collect $10 from each player
# Grand Opera Night – collect $50 from every player for opening night seats
# Income Tax refund – collect $20
# Life Insurance Matures – collect $100
# Pay Hospital Fees of $100
# Pay School Fees of $50
# Receive $25 Consultancy Fee
# You are assessed for street repairs – $40 per house, $115 per hotel
# You have won second prize in a beauty contest– collect $10
# You inherit $100
# From sale of stock you get $50
# Holiday Fund matures - Receive $100

