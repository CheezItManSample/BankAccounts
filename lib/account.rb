require 'csv'

module Bank

  class Account
    attr_accessor :id, :balance, :open_date

    def initialize(id, balance)

      raise ArgumentError.new "Balance must be positive or 0" unless balance >= 0
      @id = id
      @balance = balance
      @open_date = open_date
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
