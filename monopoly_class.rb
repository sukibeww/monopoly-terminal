class Player
    attr_reader :name, :id 
    attr_accessor :money, :property, :jail_status, :location

    @@player_counter = 0 
    def initialize(name)
        @@player_counter += 1 
        @name = name 
        @money = 4000
        @property = {} 
        @jail_status = false 
        @jail_time = 0 
        @location = 0 
        @id = "P#{@@player_counter.to_s()}"
    end

    def lap() 
        @money += 1000
    end 

    def bribe
        if(@money > 300 && @jail_time >= 1) 
            puts "Do you want to bribe your way out of jail? ($300)"
            puts "1.Yes"
            puts "2.No"
            player_input = gets.strip 
            case player_input
            when "1"
                @money -= 300 
                @jail_time = 0 
                @jail_status = false
                puts "You are free!"
            when "2"
                puts "You lose a turn" 
                @jail_time -= 1
            end 
        end 
    end 

    def buy_property(property)
        if(@money >= property.buy_cost)
            property_name_sym = property.name.to_sym
            @property.merge!("#{property_name_sym}": property)
        else 
            puts "Not enought money" 
        end 
    end 

    def toss_dice()
        random_dice = rand(1..6) 
        puts "You rolled #{random_dice}"
        @location += random_dice 
        if(@location > 23) 
            @location -= 23 
            lap() 
        end 
    end 
end 

class Tile 
    attr_accessor :player_in
    def initialize 
        @player_in = [] 
    end 

    def move_in(player)
        puts "Move in Diagnostic : #{player.class}"
        puts "Move in Diagnostic2 : #{@player_in.class}"
        @player_in.push(player)
    end 
    
    def move_out(player)
        delete_index = -1 
        result_array = @player_in
        @player_in.each_with_index do |p, index|
            if(p.name == player.name)
                delete_index = index 
                break 
            end 
        end 
        result_array.delete_at(delete_index)
        return result_array
    end 

    def in?
        player_inside = "" 
        if(@player_in != nil) 
            # puts "Diagnostic in? = #{player_in.class}"
            # puts "Diagnostic in?3 = #{@player_in}"
            @player_in.each do |player| 
                if(player.is_a? Player)
                    # puts "Diagnostic in?2 = #{player.class}"
                    player_inside << player.id << " "
                end 
            end 
        end 
        return player_inside
    end 

end 

class Property < Tile
    attr_reader :name, :id
    attr_accessor :rent, :buy_cost, :owner, :tier
    def initialize(name, buy_cost, id)
        super()
        @name = name 
        @id = id
        @rent = buy_cost/2
        @buy_cost = buy_cost
        @owner = nil 
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
            puts "Not enought money"
        end 
    end 

    def rent(player)
        if(player.money >= @rent) 
            player.money -= @rent 
        else
            puts "Not enought money" 
        end 
        return player
    end 

end 

class Chance < Tile
    
    def initialize
        super()
        @random_chance = 0 
    end

    def draw()
        @random_chance = rand(1..5)
    end 

    def read(player)
        @random_chance = draw() 
        case @random_chance
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

class CommunityChest < Tile 

    def initialize
        super()
        @random_community_chest = 0 
    end

    def draw()
        @random_community_chest = rand(1..5)
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

class Start < Tile 

    def initialize()
        super()
    end 

end 

class Jail < Tile

    def initialize()
        super()
        @player_in_jail = {} 
    end 
    
    def check_index(player, index) 
        case index 
        when 6 
            player = go_to_jail(player)
        when 18 
            pass_by_jail() 
        end 
        return player 
    end 

    def go_to_jail(player)
        player.jail_status = true 
        player.jail_time = 2 
        @player_in_jail.merge!(player.name.to_sym(), player)
    end 

    def pass_by_jail()
        puts "passing by the jail" 
    end 
end 

class FreeParking < Tile

    def initialize
        super()
    end 

    def free_parking(player, player_position)
        #move player to the desired position 
    end 
end