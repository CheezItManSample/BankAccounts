
# savings_account.rb

module Bank
  class SavingsAccount < Bank::Account
    def initialize(id, balance, open_date = nil)
      raise ArgumentError.new "The balance must be at least $10" if balance < 10

      super(id, balance, open_date)
    end

    def withdraw(amount)

      if ( (@balance - 10) < (amount + 2))
        puts "That would bring the balance below 10"
      else
        @balance -= 2
        super(amount)
      end
    end

    def add_interest(rate)
      raise ArgumentError.new "Must be a positive interest rate" if rate <= 0

      interest = @balance * rate/100.0
      @balance += interest
      return interest
    end
  end
end
