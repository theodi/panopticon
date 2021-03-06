Given /^two artefacts exist$/ do
  @artefact, @related_artefact = create_two_artefacts
end

Given /^two course artefacts exist$/ do
  @artefact, @related_artefact = create_two_course_artefacts
end

Given /^the first artefact is in draft$/ do
  Artefact.observers.disable :update_search_observer do
    Artefact.first.update_attributes!('state' => 'draft')
  end
end

Given /^the first artefact is live$/ do
  Artefact.observers.disable :update_search_observer do
    Artefact.last.update_attributes!('state' => 'live')
  end
end

Given /^two non-publisher artefacts exist$/ do
  @artefact, @related_artefact = create_two_artefacts("smart-answers")
end

When /^I change the title of the first artefact$/ do
  visit edit_artefact_path(@artefact)
  @new_name = "Some other new name"
  fill_in "Name", :with => @new_name
end

When /^I change the slug of the first artefact to "([^"]*)"$/ do |slug|
  visit edit_artefact_path(@artefact)
  fill_in "Slug", :with => slug
end

When /^I save$/ do
  click_button 'Save and continue editing'
end

Then /^I should be redirected back to the edit page$/ do
  assert_equal edit_artefact_url(@artefact), page.current_url
end

Then /^I should see an indication that the save failed$/ do
  assert page.has_content?('Failed to save item')
  assert page.has_content?('must be usable in a URL')
end

When /^I save, indicating that I want to continue editing afterwards$/ do
  click_button 'Save and continue editing'
end

When /^I save, indicating that I want to go to the item$/ do
  click_button 'Save and go to item'
end

Then /^I should see the edit form again$/ do
  assert page.has_css?('form.artefact')
end

Then /^I should see an indication that the save worked$/ do
  assert_match /Panopticon item updated/, page.body
end

When /^I create a relationship between them$/ do
  visit edit_artefact_path(@artefact)
  select_related_artefact @related_artefact
end

Then /^I should be redirected to (.*)$/ do |app|
  check_redirect app, (@artefact || Artefact.last)
end

Given /^the artefacts are related$/ do
  add_related_artefact @artefact, @related_artefact
end

When /^I destroy their relationship$/ do
  visit edit_artefact_path(@artefact)
  unselect_related_artefact @related_artefact
  submit_artefact_form
end

Given /^several non-publisher artefacts exist$/ do
  @artefact, *@related_artefacts, @unrelated_artefact = create_six_artefacts("smart-answers")
end

Given /^some of the artefacts are related$/ do
  add_related_artefacts @artefact, @related_artefacts[0...(@related_artefacts.length / 2)]
end

When /^I create more relationships between them$/ do
  visit edit_artefact_path(@artefact)
  select_related_artefacts @related_artefacts[(@related_artefacts.length / 2)..-1]
end

Given /^an artefact exists$/ do
  @artefact = create_artefact
end

Given /^that artefact has the keyword "(.*?)"$/ do |keyword|
  tag = Tag.find_or_create_by(tag_id: keyword.parameterize, title: keyword, tag_type: "keyword")
  @artefact.tags << tag
  @artefact.save
end

Given /^that artefact has the role "(.*?)"$/ do |role|
  @index = role
  @artefact.roles = [role]
  @artefact.save
end

Given /^a section exists$/ do
  @section = create_section
end

Given /^two sections exist$/ do
  @sections = create_sections
end

Given /^the artefact has the section$/ do
  add_section @artefact, @section
end

Given /^the artefact has both sections$/ do
  @sections.each do |section|
    add_section @artefact, section
  end
end

When /^I add the section to the artefact$/ do
  visit edit_artefact_path(@artefact)
  select_section @section
  submit_artefact_form
end

When /^I remove the second section from the artefact$/ do
  visit edit_artefact_path(@artefact)
  unselect_section @sections[1]
  submit_artefact_form
end

When /^I visit the homepage$/ do
  visit root_path
end

Then /^I should see a link to create an item$/ do
  xpath = "//a[@href='#{new_artefact_path}']"
  assert page.has_xpath?(xpath)
end

When /^I follow the link link to create an item$/ do
  visit new_artefact_path
end

Then /^I should see the artefact form$/ do
  assert page.has_css?('form.artefact')
end

When /^I fill in the form for a course need$/ do
  fill_in "Name", with: "A key course need"
  fill_in "Slug", with: "key-course-need"
  select "Course", from: "Kind"
end

When /^I try to create a new artefact with the same need$/ do
  visit new_artefact_path(:artefact => {:need_id => @artefact.need_id})
end

Given /^I try to create a (.*) without specifying a tag$/ do |kind|
  visit new_artefact_path
  fill_in "Name", with: "My cool #{kind}"
  fill_in "Slug", with: "my-cool-#{kind.parameterize}"
  select kind, from: "Kind"
  submit_artefact_form
end

Given /^I specify the keywords "(.*?)"$/ do |keywords|
  visit new_artefact_path
  fill_in "Name", with: "My cool thing"
  fill_in "Slug", with: "my-cool-thing"
  select "Course", from: "Kind"

  page.find("#keywords").native.send_keys(keywords)

  submit_artefact_form
end

Then /^the artefact should have the keyword "(.*?)"$/ do |keyword|
  artefact = Artefact.last
  assert artefact.keywords.any? { |t| t.tag_id == keyword.parameterize }
end

Then /^I should see an error relating to (.*)$/ do |kind|
  assert page.has_content? "#{kind} tag must be specified"
end

When /^I go to edit the artefact$/ do
  visit edit_artefact_path(@artefact)
end

Then /^I should see the keywords "(.*?)"$/ do |keywords|
  assert_equal keywords, page.find('input[name="artefact[keywords]"]', visible: false).value
end
