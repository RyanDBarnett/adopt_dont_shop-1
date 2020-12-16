require 'rails_helper'

describe 'As a visitor' do
  describe "When I visit '/shelters/new'" do
    before :each do
      @shelter1 = Shelter.create!(name: "Shady Shelter", address: "123 Shady Ave", city: "Denver", state: "CO", zip: 80011)
      @shelter2 = Shelter.create!(name: "Silly Shelter", address: "123 Silly Ave", city: "Denver", state: "CO", zip: 80012)
    end

    it "I can create a new shelter" do
      visit '/shelters'

      click_link 'New Shelter'

      expect(current_path).to eq('/shelters/new')

      fill_in "name", with: 'Pa and Paws'
      fill_in "address", with: 'road avenue'
      fill_in "city", with: 'Pitt'
      fill_in "state", with: 'PA'
      fill_in "zip", with: 12345

      click_on 'Create Shelter'

      expect(current_path).to eq('/shelters')

      expect(page).to have_content("Pa and Paws")
    end

    describe "And click 'Create Shelter' without filling in a name" do
      before :each do
        visit '/shelters/new'

        click_on 'Create Shelter'
      end

      it "Then I see a message telling me that I am missing required information" do
        expect(page).to have_content("Shelter not created: Required information missing.")
      end

      it 'And I still see the new artist form' do
        expect(page).to have_button('Create Shelter')
      end
    end
  end
end
