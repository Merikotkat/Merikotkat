# encoding: UTF-8
require 'spec_helper'
require_relative 'visitationform_factory'


#  Application controllerissa on määritelty käyttäjä seuraavasti:
#  @user = {:login_id => session[:user], :type => session[:user_type], :user_name => session[:user_name]}

describe "In Linssi" do


  it "sees own credentials." do
    visit root_path

    expect(page).to have_content 'Pekka Murkka'
    expect(page).to have_content 'Tervetuloa'
#    save_and_open_page
  end

  it "once clicking 'Luo uusi lomake', sees the new form" do
    visit root_path
    click_link I18n.t('new_visitation_form')

#    save_and_open_page
  end

  it "once on the Luo uusi lomake - page, appropriate form fields are present" do
    visit root_path
    click_link I18n.t('new_visitation_form')

    expect(page).to have_content I18n.t('photographer_name', scope: [:activerecord, :attributes, :visitation_form])
    expect(page).to have_content I18n.t('visit_date', scope: [:activerecord, :attributes, :visitation_form])
    expect(page).to have_content I18n.t('camera', scope: [:activerecord, :attributes, :visitation_form])
    expect(page).to have_content I18n.t('lens', scope: [:activerecord, :attributes, :visitation_form])
    expect(page).to have_content I18n.t('teleconverter', scope: [:activerecord, :attributes, :visitation_form])
    expect(page).to have_content I18n.t('nest_id', scope: [:activerecord, :attributes, :visitation_form])
    expect(page).to have_content I18n.t('nest', scope: [:activerecord, :attributes, :visitation_form])
  end

  it "one can save temporarily the visitation form" do
    visit root_path
    click_link I18n.t('new_visitation_form')
    click_button I18n.t('save_visitation_form')

    expect(page).to have_content I18n.t('form_not_sent')
 #   save_and_open_page
  end

  it "one cannot send forms without mandatory information" do
    visit root_path
    click_link I18n.t('new_visitation_form')
    click_button I18n.t('submit_visitation_form')

    expect(page).to have_content I18n.t('errors_in_form')
#    save_and_open_page
  end

  it "Once sending an invalid form, system displays appropriate error messages" do
    visit root_path
    click_link I18n.t('new_visitation_form')
    click_button I18n.t('submit_visitation_form')

    #expect(page).to have_content I18n.t('error_value_must_be_number')
    expect(page).to have_content I18n.t('error_must_be_present')
    expect(page).to have_content I18n.t('error_invalid_photographer_id')
    expect(page).to have_content I18n.t('error_date_invalid')
    # save_and_open_page
  end

  it "Once temporarily saved, is visible in appropriate view" do
    visit root_path
    click_link I18n.t('new_visitation_form')
    fill_in(I18n.t('nest', scope: [:activerecord, :attributes, :visitation_form]), :with => 'Funky')

    click_button I18n.t('save_visitation_form')
    click_link I18n.t('unsubmitted')

    expect(page).to have_content 'Funky'
    # save_and_open_page
  end

  it "Pagination is not visible in unsubmitted when less than 5 forms", js: true do
    create_visitation_forms 4

    visit root_path
    click_link I18n.t('unsubmitted')

    page.assert_selector(:xpath, '//div[@id="pagination"]/a', :count => 0)

  end

  it "Pagination is visible in unsubmitted when over 5 forms", js: true do
    create_visitation_forms 7

    visit root_path
    click_link I18n.t('unsubmitted')

    page.assert_selector(:xpath, '//div[@id="pagination"]/a', :count => 2)

  end

  it "Sorting works for nest id both ways", js: true do

    visit root_path

    click_link I18n.t('new_visitation_form')
    fill_in(I18n.t('nest_id', scope: [:activerecord, :attributes, :visitation_form]), :with => '1')
    click_button I18n.t('save_visitation_form')

    click_link I18n.t('new_visitation_form')
    fill_in(I18n.t('nest_id', scope: [:activerecord, :attributes, :visitation_form]), :with => '3')
    click_button I18n.t('save_visitation_form')

    click_link I18n.t('new_visitation_form')
    fill_in(I18n.t('nest_id', scope: [:activerecord, :attributes, :visitation_form]), :with => '2')
    click_button I18n.t('save_visitation_form')

    click_link I18n.t('unsubmitted')
    within('thead tr:nth-child(1) th:nth-child(1)') do
      all('a')[1].click
      # click_link '&#9650;'
    end

    for i in 1..3 do
      within('tbody tr:nth-child(' + i.to_s +  ') td:nth-child(1)') do
        page.should have_content i.to_s
      end
    end

    within('thead tr:nth-child(1) th:nth-child(1)') do
      all('a')[0].click
      #click_link '&#9660;'
    end

    for i in 1..3 do
      within('tbody tr:nth-child(' + i.to_s +  ') td:nth-child(1)') do
        page.should have_content (i-4).abs.to_s
      end
    end

  end


  it "Visitation form - Add new bird creates new div for new bird", js: true do
    visit root_path
    click_link I18n.t('new_visitation_form')

    click_button I18n.t('add_bird')

    page.assert_selector('.bird-div', :count => 2)

  end



  it "Visitation form - Add new bird and delete new bird box", js: true do

    visit root_path
    click_link I18n.t('new_visitation_form')

    click_button I18n.t('add_bird')
    page.assert_selector('.bird-div', :count => 2)

    within('#birds-div .bird-div:nth-child(2)') do
      click_link I18n.t('delete') + " " + I18n.t('bird')
    end
    page.evaluate_script('window.confirm = function() { return true; }')
    page.assert_selector('.bird-div', :count => 1)

  end


  it "Visitation form - User cannot delete only bird in form", js: true do

    visit root_path
    click_link I18n.t('new_visitation_form')


    page.assert_selector('.bird-div', :count => 1)

    within('#birds-div .bird-div:nth-child(1)') do
      click_link I18n.t('delete') + " " + I18n.t('bird')
    end
    page.evaluate_script('window.confirm = function() { return true; }')
    page.evaluate_script('window.alert = function() { return true; }')


    page.assert_selector('.bird-div', :count => 1)

  end


  def create_visitation_forms amount
    for i in 1..amount
      Visitationform_factory.GetValidVisitationForm
    end
  end

  def fill_autocomplete(field, options = {})
    fill_in field, with: options[:with]

    page.execute_script %Q{ $('##{field}').trigger('focus') }
    page.execute_script %Q{ $('##{field}').trigger('keydown') }
    selector = %Q{ul.ui-autocomplete li.ui-menu-item a:contains("#{options[:select]}")}

    page.should have_selector('ul.ui-autocomplete li.ui-menu-item a')
    page.execute_script %Q{ $('#{selector}').trigger('mouseenter').click() }
  end


  it "Can send a form with appropriate information", js: true do
    visit root_path
    click_link I18n.t('new_visitation_form')

    field = I18n.t('photographer_name', scope: [:activerecord, :attributes, :visitation_form])
    selector = 'MATTI AALTO'

    fill_autocomplete("visitation_form_photographer_name", with: 'AALTO', select: selector)

  # fill_in(I18n.t('photographer_name', scope: [:activerecord, :attributes, :visitation_form]), :with => 'MATTI AALTO (2890)')
  #  fill_in('#visitation_form_photographer_id', :with => 2890)
    fill_in(I18n.t('visit_date', scope: [:activerecord, :attributes, :visitation_form]), :with => '04.03.2014')
    fill_in(I18n.t('camera', scope: [:activerecord, :attributes, :visitation_form]), :with => 'Canon EOS 400D')
    fill_in(I18n.t('lens', scope: [:activerecord, :attributes, :visitation_form]), :with => 'Lenzman 4000')
    fill_in(I18n.t('teleconverter', scope: [:activerecord, :attributes, :visitation_form]), :with => 'Teleconv II')
    fill_in(I18n.t('nest_id', scope: [:activerecord, :attributes, :visitation_form]), :with => '223')

    fill_in(I18n.t('nest', scope: [:activerecord, :attributes, :visitation_form]), :with => 'Funky')
    fill_in(I18n.t('municipality', scope: [:activerecord, :attributes, :visitation_form]), :with => 'AITOLA')

    within("#birds_3") do
      attach_file("files[]",'spec/features/img/Lolcat.jpg')
    end

    sleep(3)

    click_button I18n.t('submit_visitation_form')

    expect(page).to have_content I18n.t('form_already_sent')
    page.should_not have_content "keksimonsteri"

  end


  #it "Cannot add same image twice", js: true do
  #  visit root_path
  #  click_link I18n.t('new_visitation_form')
  #
  #  within("#birds_3") do
  #    attach_file("files[]",'spec/features/img/Lolcat.jpg')
  #  end
  #  page.assert_selector('.image', :count => 1)
  #  within("#birds_3") do
  #    attach_file("files[]",'spec/features/img/Lolcat.jpg')
  #  end
  #  page.evaluate_script('window.alert = function() { return true; }')
  #
  #  page.assert_selector('.image', :count => 1)
  #
  #end
end