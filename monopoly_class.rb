class Player
    attr_reader :name, :id
    attr_accessor :money, :property, :jail_status, :location, :bankrupt, :jail_time

    @@player_counter = 0
    def initialize(name)
        @@player_counter += 1
        @name = name
        @money = 1000
        @property = {}
        @jail_status = false
        @jail_time = 0
        @location = 0
        @id = "P#{@@player_counter.to_s()}"
        @bankrupt = false
    end

    def player_stat()
        if(@bankrupt == false)
            puts "Player name : #{@name}"
            puts "Player money : #{@money}"
            if (@jail_status == true)
                puts "Jail status : #{@jail_status}"
                puts "Jail time = #{@jail_time}"
            end 
        else 
            puts "#{@name} already bankrupt"
        end 
    end 

    def lap()
        puts "LAP! you earn $100"
        @money += 100
        player_stat()
    end

    def bribe?
        prompt = TTY::Prompt.new()
        if(@money > 300 && @jail_time >= 1)
            player_input = prompt.select("Do you want to bribe your way out of jail? ($300)", %w(Yes No))
            case player_input
            when "Yes"
                @money -= 300
                @jail_time = 0
                @jail_status = false
                @location = 18
                puts "You are free!"
            when "No"
                puts "You lose a turn"
                @jail_time -= 1
            end
        end
    end

    def buy_property(property)
        if(@money >= property.buy_cost)
            property_name_sym = property.name.to_sym
            @property.merge!("#{property_name_sym}": property)
            property.owner = self
            @money -= property.buy_cost
        else
            puts "Not enough money"
        end
    end

    def test_buy_property_1(property)
        #positive testing 
        puts "1. sufficient money and property ownership test"
        original_money = @money 
        original_number_of_property_owned = @property.length
        buy_property(property) 
        if(original_money > @money && property.owner == self && original_number_of_property_owned < @property.length)
            puts "Passed"
        else 
            puts "False"
        end 
    end 

    def test_buy_property_2(property)
        #positive testing 
        puts "2. insuffcient money property purchase test" 
        original_number_of_property_owned = @property.length
        @money = 10 
        original_money = @money 
        buy_property(property)
        if(original_money == @money && @property.length == original_number_of_property_owned)
            puts "Passed"
        else 
            puts "False"
        end 
    end 

    def toss_dice()
        prompt = TTY::Prompt.new()
        prompt.select("#{@name}'s turn'", %w(Roll!))
        random_dice = rand(1..6)
        puts "You rolled #{random_dice}"
        @location += random_dice
        if(@location >= 23)
            @location -= 23
            lap()
        end
    end
            
    def test_toss_dice()
        original_location = @location
        toss_dice() 
        #positive testing
        puts "1. Toss dice and movement testing"
        if(@location != original_location)
            puts "Passed"
        else 
            puts "False"
        end 
    
        puts "2. Toss dice RND range testing" 
        #reset self location 
        @location = 0 
        self_location_before = @location
        toss_dice() 
        self_location_after = @location 
        dice_range = self_location_after - self_location_before
        if(dice_range >= 1 && dice_range <= 6)
            puts "Passed"
        else 
            puts "False" 
        end 
        
        #negative testing 
        puts "3. Toss dice - lap function integration "
        self.location = 23 
        self_orignal_money = self.money
        toss_dice() 
        if(self.location > 23 && self.money == self_orignal_money)
            puts "False"
        else 
            puts "Passed"
        end 
    end  

    def rent(property)
        prompt = TTY::Prompt.new()
        if(@money >= property.rent)
            prompt.select("Property owned by #{property.owner.name}, the rent cost #{property.rent}", %w(Pay))
            @money -= property.rent
            property.owner.money += property.rent
        else
            puts "Property owned by #{property.owner.name}, the rent cost #{property.rent}"
            prompt.select("You do not have enough money.", %w(Bankrupt))
            @bankrupt = true 
        end
    end

    def test_rent(property)
        puts "1. Rent balance tester" 
        original_money = @money 
        original_owner_money = property.owner.money 
        rent(property) 
        if(original_money < @money && original_owner_money < property.owner.money)
            puts "Passed" 
        else 
            puts "False"
        end 

        puts "2. insufficent money rent bankrupt trigger tester" 
        @money = 10 
        original_money = @money 
        original_owner_money = property.owner.money 
        rent(property) 
        if(@money == original_money && property.owner.money == original_owner_money && @bankrupt)
            puts "Passed"
        else 
            puts "False"
        end 
    end 

    def go_to_jail()
        @jail_status = true
        @jail_time = 2
        @location = 18
    end
end

class Tile
    attr_accessor :player_in
    def initialize
        @player_in = {
            P1: false,
            P2: false,
            P3: false,
            P4: false
        }

    end

    def move_in(player)
        player_sym = player.id.to_sym
        @player_in[player_sym] = true
    end

    def move_out(player)
        player_sym = player.id.to_sym
        @player_in[player_sym] = false
    end

    def in?
        player_inside = ""
        @player_in.each do |key, value|
            if(value == true)
                player_inside << key.to_s << " "
            end
        end
        return player_inside
    end

    def tile_reader(player)
        prompt = TTY::Prompt.new()
        if self.is_a? Property
            property_menu(self, player)
        elsif self.is_a? Start
            prompt.select("You arrrived at the Start", %w(Continue))
            board[player.location].move_in(player)
        elsif self.is_a? Chance
            prompt.select("You arrrived at the Chance", %w(Continue))
            self.read(player)
        elsif self.is_a? CommunityChest
            prompt.select("You arrrived at the Community Chest", %w(Continue))
            self.read(player)
        elsif self.is_a? Jail
            prompt.select("You arrrived at the Jail", %w(Continue))
            self.check_index(player)
        elsif self.is_a? FreeParking
            prompt.select("You arrrived at the Free Parking", %w(Continue))
            self.free_parking(player)
        end
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
        puts player.class
        puts player.name
        puts player.money
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

class Chance < Tile
    attr_accessor :random_chance, :board
    def initialize
        super()
        @random_chance = 0
        @board = []
    end

    def draw()
        @random_chance = rand(1..5)
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
        prompt = TTY::Prompt.new()
        prompt.select("BUSTED! You are in jail now !", %w(Jailed))
        board[player.location].move_out(player)
        player.location = 6
        board[player.location].move_in(player)
        board[player.location].tile_reader(player)
    end

    def chance_2(player)
        prompt = TTY::Prompt.new()
        prompt.select("Move forward up to 5 spaces", %w(Whoosh!))
        board[player.location].move_out(player)
        player.location += 5
        board[player.location].move_in(player)
        board[player.location].tile_reader(player)
    end

    def chance_3(player)
        prompt = TTY::Prompt.new()
        prompt.select("Make general repairs on all your property–For each house pay $25", %w(Pay))
        maintenance_cost = player.property.length * 50
        if (player.money >= maintenance_cost)
            player.money -= maintenance_cost
        else
            puts "You don't have enough money"
            player.bankrupt = true
            pla 
        end
    end

    def chance_4(player)
        prompt = TTY::Prompt.new()
        prompt.select("Vacation to Sydney", %w(Whoosh!))
        board[player.location].move_out(player)
        player.location = 23
        board[player.location].move_in(player)
        board[player.location].tile_reader(player)
    end

    def chance_5(player)
        prompt = TTY::Prompt.new()
        prompt.select("To free parking", %w(Whoosh!))
        board[player.location].move_out(player)
        player.location = 12
        board[player.location].move_in(player)
        board[player.location].tile_reader(player)
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
        prompt = TTY::Prompt.new()
        prompt.select("Bank pays you dividend of $50", %w(Collect))
        player.money += 50
    end

    def community_chest_2(player)
        prompt = TTY::Prompt.new()
        if(player.money >= 200)
            prompt.select("Doctor's fees – Pay $200", %w(Pay))
            player.money -= 200
        else
            puts "Not enough money"
            player.bankrupt = true 
        end
    end

    def community_chest_3(player)
        prompt = TTY::Prompt.new()
        prompt.select("It is your birthday Collect $200", %w(Collect))
        player.money += 50
    end

    def community_chest_4(player)
        prompt = TTY::Prompt.new()
        if(player.money >= 120)
            prompt.select("Pay School Fees of $120", %w(Pay))
            player.money -= 120
        else
            puts "Not enough money"
            player.bankrupt = true
            pla
        end
    end

    def community_chest_5(player)
        prompt = TTY::Prompt.new()
        number_of_property = player.property.length
        total_cost = 80 * number_of_property
        if(player.money >= total_cost)
            prompt.select("You are assessed for street repairs – $80 per property", %w(Pay))
            player.money -= number_of_property * 60
        else
            puts "Not enough money"
            player.bankrupt = true
            pla
        end
    end
end

class Start < Tile

    attr_accessor :board

    def initialize()
        super()
        @board = []
    end

end

class Jail < Tile
    attr_accessor :player_in_jail, :board
    def initialize()
        super()
        @player_in_jail = {}
        @board = []
    end

    def check_index(player)
        puts "Player location : #{player.location}"
        case player.location
        when 6
            board[player.location].move_out(player)
            player.go_to_jail()
            puts "Player location2 : #{player.location}"
            board[player.location].move_in(player)
            update_jail(player)
            player.player_stat()
        when 18
            pass_by_jail()
        end
        return player
    end

    def update_jail(player)
        player_name_sym = player.name.to_sym()
        player_hash = {
            "#{player_name_sym}": player
        }
        @player_in_jail.merge!(player_hash)
    end

    def pass_by_jail()
        puts "Passing by Jail"
    end
end

class FreeParking < Tile
    attr_accessor :board
    def initialize()
        super()
        @board = []
    end


    def free_parking(player)
        prompt = TTY::Prompt.new()
        user_choice = prompt.select("Where do you want to park?") do |menu|
            menu.choice name: "Start", value: 0
            menu.choice name: "Darwin", value: 1
            menu.choice name: "Alice Spring", value: 2
            menu.choice name: "Chance", value: 3
            menu.choice name: "Stanley", value: 4
            menu.choice name: "Freycinet National Park", value: 5
            menu.choice name: "Jail", value: 6
            menu.choice name: "Hobart", value: 7
            menu.choice name: "Margaret River", value: 8
            menu.choice name: "Community Chest", value: 9
            menu.choice name: "Broome", value: 10
            menu.choice name: "Esperance", value: 11
            menu.choice name: "Free Parking", value: 12, disabled:("You are here")
            menu.choice name: "Pilip Island", value: 13
            menu.choice name: "Melbourne", value: 14
            menu.choice name: "Chance_2", value: 15
            menu.choice name: "Canberra", value: 16
            menu.choice name: "Questacon", value: 17
            menu.choice name: "Pass by Jail", value: 18
            menu.choice name: "Kangaroo Island", value: 19
            menu.choice name: "Gold Coast", value: 20
            menu.choice name: "Community Chest_2", value: 21
            menu.choice name: "White Sundays", value: 22
            menu.choice name: "Sydney", value: 23
        end
        board[player.location].move_out(player)
        player.location = user_choice
        board[player.location].move_in(player)
        board[player.location].tile_reader(player)
    end
end
