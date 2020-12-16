require 'rails_helper'

describe 'As a visitor' do
  describe 'When I visit the new application page where I see a form' do
    describe "When I fill in this form with Name, Address, City, State, Zip and click submit'" do
      before :each do
        visit '/applications/new'

        fill_in "name", with: 'Applicant Name 1'
        fill_in "address", with: '123 Washington Blvd'
        fill_in "city", with: 'Los Angeles'
        fill_in "state", with: 'CA'
        fill_in "zip", with: 90290

        click_on 'Submit'

        @application = Application.first
      end

      it "Then I am taken to the new application's show page and I see my Name, address information, and status 'In Progress'" do
        expect(current_path).to eq("/applications/#{@application.id}")
        expect(page).to have_content("Applicant Name: #{@application.name}")
        expect(page).to have_content("Address: #{@application.address}")
        expect(page).to have_content("City: #{@application.city}")
        expect(page).to have_content("State: #{@application.state}")
        expect(page).to have_content("Zip: #{@application.zip}")
        expect(page).to have_content("Application Status: In Progress")
      end
    end
  end
end
