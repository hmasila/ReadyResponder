require 'spec_helper'
#Don't use capybara (ie visit/have_content) and rspec matchers together  {response.status.should be(200)}

describe "Course" do
  before  do
    somebody = FactoryGirl.create(:user)
    visit new_user_session_path
    fill_in('user_email', :with => somebody.email)
    fill_in('user_password', :with => somebody.password)
    click_on 'Sign in'
  end
  
  describe " when not logged in" do
    it "should not allow much of anything" do
      click_on 'Sign Out'
      visit courses_path
      page.should_not have_content("Listing")
      page.should have_content('You need to sign in')
      visit new_course_path
      page.should have_content('You need to sign in')
      an_example = FactoryGirl.create(:course, name: 'Pottery')
      visit edit_course_path(an_example)
      page.should have_content('You need to sign in')
      page.should_not have_content('Pottery')
      visit course_path(an_example)
      page.should have_content('You need to sign in')
      page.should_not have_content('Pottery')
    end
  end
      
  describe "should display" do
   it "a list" do
      an_example = FactoryGirl.create(:course, name: 'Zombie Hunting')
      
      visit courses_path
      page.should have_content("Listing Courses")
      page.should have_content("LIMS") # This is in the nav bar
      page.should have_link(an_example.name)
      click_on an_example.name
      page.should have_content(an_example.name)
    end

    it "a new course form that creates a course" do
      visit courses_path
      click_on "New Course"
      page.should have_content('New Course')
      fill_in 'course_name', :with => 'Basket Weaving'
      select('Active', :from => 'course_status')
      fill_in 'course_description', :with => 'A creative and fulfilling pastime'
      #select('Active', :from => 'course_skill')
      select('General', :from => 'course_category')
      fill_in 'course_duration', :with => '2'
      fill_in 'course_term', :with => '20'
      fill_in 'course_comments', :with => 'Not for the faint of heart'
      click_on 'Create Course'
      visit courses_path
      page.should have_content('Basket Weaving')
    end
    
    it 'should update a course' do
      an_example = FactoryGirl.create(:course, name: 'Zombie Hunting')
      visit edit_course_path(an_example)
      fill_in 'course_name', :with => 'Skydiving'
      click_on 'Update Course'
      visit courses_path
      page.should_not have_content('Zombie Hunting')
      page.should have_content('Skydiving')
    end
  end
end
