# encoding: UTF-8
require 'spec_helper'

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
    click_link I18n.t('new_visitation_form').upcase

#    save_and_open_page
  end

  it "once on the Luo uusi lomake - page, pedobear form fields are present" do
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
    click_link I18n.t('new_visitation_form').upcase
    click_button I18n.t('save_visitation_form')

    expect(page).to have_content I18n.t('form_not_sent')
 #   save_and_open_page
  end

  it "one cannot send forms without mandatory information" do
    visit root_path
    click_link I18n.t('new_visitation_form').upcase
    click_button I18n.t('submit_visitation_form')

    expect(page).to have_content I18n.t('errors_in_form')
#    save_and_open_page
  end

  it "Once sending an invalid form, system displays appropriate error messages" do
    visit root_path
    click_link I18n.t('new_visitation_form').upcase
    click_button I18n.t('submit_visitation_form')

    #expect(page).to have_content I18n.t('error_value_must_be_number')
    expect(page).to have_content I18n.t('error_must_be_present')
    expect(page).to have_content I18n.t('error_invalid_photographer_id')
    expect(page).to have_content I18n.t('error_date_invalid')
    # save_and_open_page
  end

  it "Once temporarily saved, is visible in appropriate view" do
    visit root_path
    click_link I18n.t('new_visitation_form').upcase
    fill_in(I18n.t('nest', scope: [:activerecord, :attributes, :visitation_form]), :with => 'Funky')

    click_button I18n.t('save_visitation_form')
    click_link I18n.t('unsubmitted')

    expect(page).to have_content 'Funky'
    # save_and_open_page
  end

  #it "Can send a form with appropriate information" do
  #  visit root_path
  #  click_link I18n.t('new_visitation_form')
  #
  #  field = I18n.t('photographer_name', scope: [:activerecord, :attributes, :visitation_form])
  #  fill_in field, :with => 'MATTI AALTO'
  #  page.execute_script %Q{ $('##{field}').trigger("focus") }
  #  page.execute_script %Q{ $('##{field}').trigger("keydown") }
  #  selector = "ul.ui-autocomplete a:contains('#{options[:select]}')"
  #
  #  page.execute_script "$(\"#{selector}\").mouseenter().click()"
  #
  # # fill_in(I18n.t('photographer_name', scope: [:activerecord, :attributes, :visitation_form]), :with => 'MATTI AALTO (2890)')
  ##  fill_in('#visitation_form_photographer_id', :with => 2890)
  #  fill_in(I18n.t('visit_date', scope: [:activerecord, :attributes, :visitation_form]), :with => '04.03.2014')
  #  fill_in(I18n.t('camera', scope: [:activerecord, :attributes, :visitation_form]), :with => 'Canon EOS 400D')
  #  fill_in(I18n.t('lens', scope: [:activerecord, :attributes, :visitation_form]), :with => 'Lenzman 4000')
  #  fill_in(I18n.t('teleconverter', scope: [:activerecord, :attributes, :visitation_form]), :with => 'Teleconv II')
  #  fill_in(I18n.t('nest_id', scope: [:activerecord, :attributes, :visitation_form]), :with => '223')
  #
  #  fill_in(I18n.t('nest', scope: [:activerecord, :attributes, :visitation_form]), :with => 'Funky')
  #
  #  within("#birds_3") do
  #    attach_file("files[]",'spec/features/img/Lolcat.jpg')
  #  end
  #  click_button I18n.t('submit_visitation_form')
  #
  #  save_and_open_page
  #
  #end
end