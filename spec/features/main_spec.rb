require 'spec_helper'

#  Application controllerissa on määritelty käyttäjä seuraavasti:
#  @user = {:login_id => session[:user], :type => session[:user_type], :user_name => session[:user_name]}

describe "On login page" do

  it "should have login link if not yet logged in" do
    visit root_path

    expect(page).to have_content 'Tervetuloa'
  end
end