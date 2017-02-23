module Bank

  class Account
    attr_accessor :id, :balance, :open_date

    def initialize(id, balance, open_date = nil)

      raise ArgumentError.new "Balance must be positive or 0" unless balance >= 0
      @id = id
      @balance = balance
      @open_date = open_date
    end

    def self.all
      accounts = []

      CSV.read("support/accounts.csv").each do |line|
        id = line[0].to_i
        balance = line[1].to_i
        open_date = line[2]
        accounts << Account.new(id, balance, open_date)
      end

      accounts
    end

    def self.find(account_number)

      CSV.read("support/accounts.csv").each do |line|
        if line[0] == account_number.to_s
            return Bank::Account.new(line[0].to_i, line[1].to_i, line[2])
        end
      end
      raise ArgumentError.new "Account does not exist"
    end

    def withdraw(amount)
      raise ArgumentError.new if amount < 0

      if amount > balance
        puts "That would bring the balance below 0"
      else
        @balance = @balance - amount
      end

      balance
    end

    def deposit(amount)
      raise ArgumentError.new if amount < 0
      @balance += amount
    end
  end
end
