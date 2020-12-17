require 'rails_helper'

describe 'As a visitor' do
  describe 'When I visit an applications show page' do
    before :each do
      @shelter = Shelter.create!(name: "Shady Shelter", address: "123 Shady Ave", city: "Denver", state: "CO", zip: 80011)
      @pet1 = @shelter.pets.create!(image:"", name: "Thor", description: "dog", approximate_age: 2, sex: "male")
      @pet2 = @shelter.pets.create!(image:"", name: "Athena", description: "cat", approximate_age: 3, sex: "female")
      @pet3 = @shelter.pets.create!(image:"", name: "Zeus", description: "dog", approximate_age: 4, sex: "male")
      @application = Application.create!(
        name: "John Doe",
        address: '321 Happy Ave',
        city: 'Irvine',
        state: 'CA',
        zip: 90323,
        description: 'We live near Disneyland',
        status: 'In Progress'
      )

      Adoption.create!(pet: @pet1, application: @application)
      Adoption.create!(pet: @pet2, application: @application)
      Adoption.create!(pet: @pet3, application: @application)

      visit "/applications/#{@application.id}"
    end

    describe "Then I see a section on the page to 'Add a Pet to this Application'" do
      it 'In that section I see an input where I can search for Pets by name' do
        within '#add-a-pet-search-form' do
          expect(page).to have_content('Add a Pet to this Application')
          expect(page).to have_field('add-a-pet-search')
        end
      end

      describe "When I fill in this field with a Pet's name and I click submit" do
        describe 'Then I am taken back to the application show page' do
          before :each do
            @bubba = @shelter.pets.create!(image:"", name: "Bubba", description: "dog", approximate_age: 1, sex: "male")

            within '#add-a-pet-search-form' do
              fill_in 'add-a-pet-search', with: 'Bubba'

              click_on 'Submit'
            end
          end
          it 'And under the search bar I see any Pet whose name matches my search' do
            expect(current_path).to eq("/applications/#{@application.id}")

            within '#add-a-pet-search-results' do
              expect(page).to have_content('Bubba')
            end
          end

          it "Then next to each matching Pet's name I see a button to 'Adopt this Pet'" do
            within '#add-a-pet-search-results' do
              expect(page).to have_link('Adopt this Pet')
            end
          end

          describe "When I click a 'Adopt this Pet' buttons" do
            before :each do
              within '#add-a-pet-search-results' do
                click_on('Adopt this Pet')
              end
            end

            it 'Then I am taken back to the application show page' do
              expect(current_path).to eq("/applications/#{@application.id}")
            end

            it 'Then I see the Pet I want to adopt listed on this application' do
              within '.applied-pets' do
                expect(page).to have_link('Bubba')
              end
            end
          end
        end
      end
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
