#!/usr/bin/env ruby

require 'mechanize'
require 'Pry'

agent = Mechanize.new

# Get the sign in page
page  = agent.get 'https://www.tripit.com/account/login'

# Fill out the login form
form                     = page.form_with :id => 'authenticate'
form.login_email_address = ARGV[0]
form.login_password      = ARGV[1]
form.submit

# Go to the settings page
page  = agent.get 'https://www.tripit.com/account/edit'

# Check if logged in
logged_in = page.body.include? "You're logged in as #{ARGV[0]}"

Pry.start(binding)
