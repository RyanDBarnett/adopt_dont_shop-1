require 'rails_helper'

describe 'As a visitor' do
  describe 'When I visit an applications show page' do
    before :each do
      shelter = Shelter.create!(name: "Shady Shelter", address: "123 Shady Ave", city: "Denver", state: "CO", zip: 80011)
      @pet1 = shelter.pets.create!(image:"", name: "Thor", description: "dog", approximate_age: 2, sex: "male")
      @pet2 = shelter.pets.create!(image:"", name: "Athena", description: "cat", approximate_age: 3, sex: "female")
      @pet3 = shelter.pets.create!(image:"", name: "Zeus", description: "dog", approximate_age: 4, sex: "male")
      @application = Application.create!(
        name: "John Doe",
        address: '321 Happy Ave',
        city: 'Irvine',
        state: 'CA',
        zip: 90323,
        description: 'We live near Disneyland',
        status: 'In Progress'
      )

      ApplicationPet.create!(pet: @pet1, application: @application)
      ApplicationPet.create!(pet: @pet2, application: @application)
      ApplicationPet.create!(pet: @pet3, application: @application)

      visit "/applications/#{@application.id}"
    end

    describe "Then I can see the applicant's" do
      it 'name' do
        expect(page).to have_content("Applicant Name: #{@application.name}")
      end

      it 'address' do
        expect(page).to have_content("Address: #{@application.address}")
      end

      it 'city' do
        expect(page).to have_content("City: #{@application.city}")
      end

      it 'state' do
        expect(page).to have_content("State: #{@application.state}")
      end

      it 'zip' do
        expect(page).to have_content("Zip: #{@application.zip}")
      end

      it 'description' do
        expect(page).to have_content('Applicant description why their home would be good for this pet: ')
        expect(page).to have_content(@application.description)
      end
    end

    it 'Then I see the names of all pets that this application is for (each name should link to their show page)' do
      expect(page).to have_link(@pet1.name, href: "/pets/#{@pet1.id}")
      expect(page).to have_link(@pet2.name, href: "/pets/#{@pet2.id}")
      expect(page).to have_link(@pet3.name, href: "/pets/#{@pet3.id}")
    end

    it "Then I see the application's status" do
      expect(page).to have_content("Application Status: #{@application.status}")
    end
  end
end
