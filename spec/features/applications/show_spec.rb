require 'rails_helper'

describe 'As a visitor' do
  describe 'When I visit an applications show page' do
    before :each do
      @shelter = Shelter.create!(name: "Shady Shelter", address: "123 Shady Ave", city: "Denver", state: "CO", zip: 80011)
      @thor = @shelter.pets.create!(image:"", name: "Thor", description: "dog", approximate_age: 2, sex: "male")
      @bubba = @shelter.pets.create!(image:"", name: "Bubba", description: "dog", approximate_age: 1, sex: "male")
      @application = Application.create!(
        name: "John Doe",
        address: '321 Happy Ave',
        city: 'Irvine',
        state: 'CA',
        zip: 90323,
        description: nil,
        status: 'In Progress'
      )

      visit "/applications/#{@application.id}"
    end

    describe 'And I have not added any pets to the application' do
      it 'Then I do not see a section to submit my application' do
        expect(page).to_not have_css('#application-submission-section')
      end
    end

    describe 'And I have added one or more pets to the application' do
      before :each do
        Adoption.create!(pet: @bubba, application: @application)

        visit "/applications/#{@application.id}"
      end

      it 'Then I see a section to submit my application with input to enter why I would make a good owner' do
        within '#application-submission-section' do
          expect(page).to have_content('Please describe why you would make a good pet owner')
          expect(page).to have_field(:description)
        end
      end

      describe 'When I fill in that input and click submit' do
        before :each do
          within '#application-submission-section' do
            fill_in :description, with: 'I am the best pet owner ever nuff said.'
            click_on 'submit'
          end
        end

        it "Then I am taken back to the application's show page" do
          expect(current_path).to eq("/applications/#{@application.id}")
        end

        it "And I see an indicator that the application is 'Pending'" do
          expect(page).to have_content("Application Status: Pending")
        end

        it 'And I see all the pets that I want to adopt' do
          within '#applied-pets-list' do
            expect(page).to have_link(@bubba.name, href: "/pets/#{@bubba.id}")
          end
        end

        it 'And I do not see a section to add more pets to this application' do
          expect(page).to_not have_css('#add-a-pet-search-container')
        end
      end
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
            within '#add-a-pet-search-form' do
              fill_in 'add-a-pet-search', with: 'Thor'

              click_on 'Submit'
            end
          end
          it 'And under the search bar I see any Pet whose name matches my search' do
            expect(current_path).to eq("/applications/#{@application.id}")

            within '#add-a-pet-search-results' do
              expect(page).to have_content('Thor')
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
              within '#applied-pets-list' do
                expect(page).to have_link('Thor')
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
        @application.update! description: 'Test description'

        visit "/applications/#{@application.id}"

        expect(page).to have_content('Applicant description why their home would be good for this pet: Test description')
      end
    end

    it 'Then I see the names of all pets that this application is for (each name should link to their show page)' do
      Adoption.create!(pet: @bubba, application: @application)

      visit "/applications/#{@application.id}"

      expect(page).to have_link(@bubba.name, href: "/pets/#{@bubba.id}")
    end

    it "Then I see the application's status" do
      expect(page).to have_content("Application Status: #{@application.status}")
    end
  end
end
