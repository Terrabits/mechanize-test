#!/usr/bin/env ruby

require 'mechanize'
require 'Pry'

class TripIt
  attr_accessor :username

  def initialize
    @base_url = 'https://www.tripit.com'
    @agent   = Mechanize.new
    @agent.user_agent_alias = "Mac Safari"
    @agent.redirect_ok = false
  end

  def login(password, username=nil)
    @username ||= username

    page = get '/account/login'
    form = page.form_with id: 'authenticate'
    form.login_email_address = @username
    form.login_password      = password
    form.submit
    logged_in?
  end

  def logged_in?
    account_edit_page.body.include? "You're logged in as #{@username}"
  end

  def logout
    @agent.reset
  end

  def trips
    trips_page.css('.container .trip-display .display-name').map(&:text)
  end

  def get(url)
    @agent.get(@base_url + url)
  end

  private

  def account_edit_page
    get '/account/edit'
  end

  def trips_page
    get '/trips'
  end
end

# tripit = TripIt.new
# tripit.username = 'email@example.com'
# tripit.login('password') => true
# tripit.logged_in?        => true
# tripit.trips             => [..]
# tripit.logout
# tripit.logged_in?        => false
Pry.start(binding)
