require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'
require 'csv'
require_relative '../lib/account'

describe "Wave 1" do
  describe "Account#initialize" do
    it "Takes an ID and an initial balance" do
      id = 1337
      balance = 100.0
      account = Bank::Account.new(id, balance)

      account.must_respond_to :id
      account.id.must_equal id

      account.must_respond_to :balance
      account.balance.must_equal balance
    end

    it "Raises an ArgumentError when created with a negative balance" do
      # Note: we haven't talked about procs yet. You can think
      # of them like blocks that sit by themselves.
      # This code checks that, when the proc is executed, it
      # raises an ArgumentError.
      proc {
        Bank::Account.new(1337, -100.0)
      }.must_raise ArgumentError
    end

    it "Can be created with a balance of 0" do
      # If this raises, the test will fail. No 'must's needed!
      Bank::Account.new(1337, 0)
    end
  end

  describe "Account#withdraw" do
    it "Reduces the balance" do
      start_balance = 100.0
      withdrawal_amount = 25.0
      account = Bank::Account.new(1337, start_balance)

      account.withdraw(withdrawal_amount)

      expected_balance = start_balance - withdrawal_amount
      account.balance.must_equal expected_balance
    end

    it "Returns the modified balance" do
      start_balance = 100.0
      withdrawal_amount = 25.0
      account = Bank::Account.new(1337, start_balance)

      updated_balance = account.withdraw(withdrawal_amount)

      expected_balance = start_balance - withdrawal_amount
      updated_balance.must_equal expected_balance
    end

    it "Outputs a warning if the account would go negative" do
      start_balance = 100.0
      withdrawal_amount = 200.0
      account = Bank::Account.new(1337, start_balance)

      # Another proc! This test expects something to be printed
      # to the terminal, using 'must_output'. /.+/ is a regular
      # expression matching one or more characters - as long as
      # anything at all is printed out the test will pass.
      proc {
        account.withdraw(withdrawal_amount)
      }.must_output(/.+/)
    end

    it "Doesn't modify the balance if the account would go negative" do
      start_balance = 100.0
      withdrawal_amount = 200.0
      account = Bank::Account.new(1337, start_balance)

      updated_balance = account.withdraw(withdrawal_amount)

      # Both the value returned and the balance in the account
      # must be un-modified.
      updated_balance.must_equal start_balance
      account.balance.must_equal start_balance
    end

    it "Allows the balance to go to 0" do
      account = Bank::Account.new(1337, 100.0)
      updated_balance = account.withdraw(account.balance)
      updated_balance.must_equal 0
      account.balance.must_equal 0
    end

    it "Requires a positive withdrawal amount" do
      start_balance = 100.0
      withdrawal_amount = -25.0
      account = Bank::Account.new(1337, start_balance)

      proc {
        account.withdraw(withdrawal_amount)
      }.must_raise ArgumentError
    end
  end

  describe "Account#deposit" do
    it "Increases the balance" do
      start_balance = 100.0
      deposit_amount = 25.0
      account = Bank::Account.new(1337, start_balance)

      account.deposit(deposit_amount)

      expected_balance = start_balance + deposit_amount
      account.balance.must_equal expected_balance
    end

    it "Returns the modified balance" do
      start_balance = 100.0
      deposit_amount = 25.0
      account = Bank::Account.new(1337, start_balance)

      updated_balance = account.deposit(deposit_amount)

      expected_balance = start_balance + deposit_amount
      updated_balance.must_equal expected_balance
    end

    it "Requires a positive deposit amount" do
      start_balance = 100.0
      deposit_amount = -25.0
      account = Bank::Account.new(1337, start_balance)

      proc {
        account.deposit(deposit_amount)
      }.must_raise ArgumentError
    end
  end
end

# TODO: change 'xdescribe' to 'describe' to run these tests
describe "Wave 2" do
  describe "Account.all" do

    before do
      @accounts =  Bank::Account.all
    end

    it "Returns an array of all accounts" do
      # TODO: Your test code here!
      # Useful checks might include:
      #   - Account.all returns an array
      @accounts.must_be_instance_of Array
    end

      #   - Everything in the array is an Account
      it "Everything in the array is an Account" do
        @accounts.each do |account|
          account.must_be_instance_of Bank::Account
        end

      end


      #   - The number of accounts is correct
      it "The number of accounts is correct" do
        @accounts.length.must_equal CSV.read("support/accounts.csv").length
      end

      #   - The ID and balance of the first and last
      it "The ID and balance of the first and last" do

        @accounts.first.id.must_equal 1212
        @accounts.first.balance.must_equal 1235667

        @accounts.last.id.must_equal 15156
        @accounts.last.balance.must_equal 4356772

      end

      #       accounts match what's in the CSV file

      it "The elements match what's in the file" do

        index = 0
        CSV.read("support/accounts.csv") do |line|

          accounts[index].id.must_equal line[0].to_i
          accounts[index].balance.must_equal line[1].to_i
          accounts[index].open_date.must_equal line[2]
          index += 1
        end


      end

      # Feel free to split this into multiple tests if needed
  end

  describe "Account.find" do
    it "Returns an account that exists" do
      # TODO: Your test code here!
      account = Bank::Account.find(1217)

      account.must_be_instance_of Bank::Account
      account.id.must_equal 1217
      account.balance.must_equal 12323
      account.open_date.must_equal "2003-11-07 11:34:56 -0800"

    end

    it "Can find the first account from the CSV" do
      # TODO: Your test code here!
      account = Bank::Account.find(1212)

      account.must_be_instance_of Bank::Account
      account.id.must_equal 1212
      account.balance.must_equal 1235667
      account.open_date.must_equal "1999-03-27 11:30:09 -0800"

    end

    it "Can find the last account from the CSV" do
      # TODO: Your test code here!

      account = Bank::Account.find(15156)

      account.must_be_instance_of Bank::Account
      account.id.must_equal 15156
      account.balance.must_equal 4356772
      account.open_date.must_equal "1994-11-17 14:04:56 -0800"
    end

    it "Raises an error for an account that doesn't exist" do
      # TODO: Your test code here!
      proc { Bank::Account.find(1234567890)  }.must_raise ArgumentError

    end
  end
end
