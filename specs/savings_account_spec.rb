require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'

# TODO: uncomment the next line once you start wave 3 and add lib/savings_account.rb
require_relative '../lib/savings_account'

# Because a SavingsAccount is a kind
# of Account, and we've already tested a bunch of functionality
# on Account, we effectively get all that testing for free!
# Here we'll only test things that are different.

# TODO: change 'xdescribe' to 'describe' to run these tests
describe "SavingsAccount" do
  before do
    @savings_account = Bank::SavingsAccount.new(12345, 10000)
  end

  describe "#initialize" do
    it "Is a kind of Account" do
      # Check that a SavingsAccount is in fact a kind of account
      @savings_account.must_be_kind_of Bank::Account

      @savings_account.must_be_kind_of Bank::SavingsAccount
    end

    it "Requires an initial balance of at least $10" do
      proc {
        Bank::SavingsAccount.new(1111, 9)
      }.must_raise ArgumentError

      Bank::SavingsAccount.new(1111, 10)
    end
  end

  describe "#withdraw" do
    it "Applies a $2 fee each time" do
      # TODO: Your test code here!
      @savings_account.withdraw(10).must_equal 10000 - 10 - 2

      @savings_account.withdraw(8).must_equal 10000 - 10 - 2 - 8 - 2
    end

    it "Outputs a warning if the balance would go below $10" do
      # TODO: Your test code here!
      proc {
        @savings_account.withdraw(10000 - 11)
      }.must_output(/.+/)
    end

    it "Doesn't modify the balance if it would go below $10" do
      # TODO: Your test code here!
      @savings_account.withdraw(10000 - 9)
      @savings_account.balance.must_equal 10000.00
    end

    it "Doesn't modify the balance if the fee would put it below $10" do
      # TODO: Your test code here!
      @savings_account.withdraw(10000 - 11)
      @savings_account.balance.must_equal 10000.00
    end
  end

  describe "#add_interest" do
    it "Returns the interest calculated" do
      # TODO: Your test code here!
      @savings_account.add_interest(0.25).must_equal 25.0
    end

    it "Updates the balance with calculated interest" do
      # TODO: Your test code here!
      @savings_account.add_interest(0.25)
      @savings_account.balance.must_equal 10025.0
    end

    it "Requires a positive rate" do
      # TODO: Your test code here!
      proc {
        @savings_account.add_interest(0)
      }.must_raise ArgumentError
      proc {
        @savings_account.add_interest(-0.25)
      }.must_raise ArgumentError


    end
  end
end
