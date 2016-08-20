#!/usr/bin/env ruby

require 'mechanize'
require 'Pry'

class GoogleCalendar
  attr_accessor :username

  def initialize
    @agent   = Mechanize.new
    @agent.user_agent_alias = "Mac Safari"
  end

  def login(password, username=nil)
    @username ||= username

    # submit email
    follow_redirect
    page = login_page
    form = page.form_with name: nil
    form.Email = @username
    form.submit

    # follow redirect...
    page = @agent.page

    # submit password
    form = page.form_with name: nil
    form.Passwd = password
    form.submit

    # follow redirect...
    page = @agent.page

    # submit two-factor
    form = page.form_with name: nil
    puts "Enter two-factor pin:"
    form.Pin = gets.strip
    form.submit

    # follow redirect...
    # page = @agent.page

    logged_in?
  end

  def logged_in?
    acct_info = main_page.css('[aria-label="Account Information"]')
    !acct_info.empty? && acct_info.to_s.include?(@username)
  end

  def logout
    @agent.reset
  end

  def get(url)
    @agent.get(url)
  end

  private

  def follow_redirect(follow=true)
    @agent.redirect_ok = follow
  end

  def login_page
    get 'https://accounts.google.com/ServiceLogin'
  end

  def main_page
    get 'https://calendar.google.com/calendar/render#main_7'
  end

end

gc = GoogleCalendar.new
gc.username = 'nick.lalic@gmail.com'
gc.login 'GT#w16NFvu337u!!nPEP3i&$1^NKuJgl'
Pry.start(binding)
