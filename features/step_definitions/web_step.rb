# Note: This is not the old cucumber-rails web_steps.rb
#       It is a subset of the useful steps that aren't terrible

require 'uri'

#GIVEN

Given /^(?:I )am a registered user$/ do
  @user = User.create!(:username => 'Topo gigio', :email => "example@mail.com", :password => '12345678', :password_confirmation => '12345678')
end

And /^a room already exists/ do
  @owner = User.create!(:username => 'Owner', :email => "owner@mail.com", :password => '12345678', :password_confirmation => '12345678')
  @room = @owner.rooms.create!(:name => 'Room prova1', 
                              :max_participants => 5,
                              :time_from  => Time.now + 60*60*12,
                              :time_to    => Time.now + 60*70*24,
                              :latitude   => 41.908339,
                              :longitude  => 12.479098,
                              :address    => 'via delBabuino, 00187 Roma Roma, Italy',
                              :fifo       => true)
end

And /^user (.+) exists/ do |name|
  @user2 = User.create!(:username => name, :email => 'aoaoao@gmail.com', :password => '12341234', :password_confirmation => '12341234')
end


And /^(?:I )log in$/ do
  visit @test_url+"login"
  fill_in "session_email", :with => @user.email
  fill_in "session_password", :with => @user.password
  click_button('Log in')
end

#WHEN 
When /^(?:I )create a room$/ do
  @room = @user.rooms.create!(:name => 'Room prova1', 
                              :time_from => '2018-06-08 12:00', 
                              :time_to => '2018-06-08 14:00', 
                              :max_participants => 5,
                              :latitude => 41.908339,
                              :longitude => 12.479098,
                              :address => 'via delBabuino, 00187 Roma Roma, Italy')
end

When /^I visit (.*)$/ do |page_name|
	visit @test_url+"#{page_name}"
end

And /^I fill (.*) with (.*)/ do |element, value|
	fill_in element, :with => value
end

And /^I am alreay reserved/ do
  expect(@user.reservations.create!(room_id: @room.id)).not_to be nil
end

And /^I pick the first one/ do
  find('li.active').click
end

And /^I click (.*)/ do |element|
  click_on(element)
end

And /^I select TimeFrom/ do
  within('#time_from_div') do
    find('.flatpickr-input').click
  end
  within('div.flatpickr-calendar') do
    within('div.flatpickr-innerContainer') do
      within('div.flatpickr-days') do
        within('div.dayContainer') do
          find('.today').click      
        end
      end
    end
  end
end

And /^I select TimeTo/ do
  within('#time_to_div') do
    find('.flatpickr-input').click
  end
  within('div.flatpickr-calendar') do
    within('div.flatpickr-innerContainer') do
      within('div.flatpickr-days') do
        within('div.dayContainer') do
          find('.today').click      
        end
      end
    end
  end
end

#THEN 

Then /^I should see marker$/ do	
  expect(page.find('#map')).not_to be nil
  expect(page.find('#marker-0', visible: 'false')).not_to be nil
end

Then /^room has coordinates/ do
  room = Room.take
  expect(room.latitude).not_to be nil
  expect(room.longitude).not_to be nil
  expect(room.address).not_to be nil
end

Then /^I should be reserved/ do
  room = Room.take
  expect(room.reservations.exists?(user_id: @user.id)).to be true
end

Then /^I should not be reserved/ do
  room = Room.take
  expect(room.reservations.exists?(user_id: @user.id)).to be false
end

Then /^(.+) should be room host/ do |username|
  user = User.find_by(username: username)
  room = Room.take
  expect(user).not_to be nil
  expect(Power.exists?(user_id: user.id, room_id: room.id))
end