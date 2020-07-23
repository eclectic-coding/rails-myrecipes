require 'test_helper'

class ChefTest < ActiveSupport::TestCase

  def setup
    @chef = Chef.new(chefname: 'chuck', email: 'chuck@example.com')
  end

  test 'should be valid' do
    assert @chef.valid?
  end

  test 'chef name should be present' do
    @chef.chefname = ' '
    assert_not @chef.valid?
  end

  test 'chef name should be no more than 30 characters' do
    @chef.chefname = 'a' * 31
    assert_not @chef.valid?
  end

  test 'chefs email should be present' do
    @chef.email = ' '
    assert_not @chef.valid?
  end

  test 'email should not be too long' do
    @chef.email = 'a' * 245 + '@example.com'
    assert_not @chef.valid?
  end

  test 'email should accept correct format' do
    valid_emails = %w[user@example.com CHUCK@gmail.com C.first@yahoo.ca john+smith@co.uk.org]
    valid_emails.each do |e|
      @chef.email = e
      assert @chef.valid?, "#{e.inspect} should be valid"
    end
  end

  test 'should reject invalid email addresses' do
    invalid_emails = %w[user@example CHUCK@gmail,com C.first@yahoo. john+smith@co+foo.org]
    invalid_emails.each do |e|
      @chef.email = e
      assert_not @chef.valid?, "#{e.inspect} should be valid"
    end
  end

  test 'emails should be unique and case insensitive' do
    duplicate_chef = @chef.dup
    duplicate_chef.email = @chef.email.upcase
    @chef.save
    assert_not duplicate_chef.valid?
  end

  test 'email should be lower case before hitting db' do
    mixed_email = 'JohN@ExampLe.com'
    @chef.email = mixed_email
    @chef.save
    assert_equal mixed_email.downcase, @chef.reload.email
  end
end
