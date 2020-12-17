require 'rails_helper'

describe Pet, type: :model do
  describe 'relationships' do
    it { should belong_to :shelter }
    it { should have_many :adoptions }
    it { should have_many(:applications).through(:adoptions)}
  end

  describe 'class methods' do
    describe 'filter_by_name' do
      before :each do
        @shelter = Shelter.create!(name: "Shady Shelter", address: "123 Shady Ave", city: "Denver", state: "CO", zip: 80011)
        @thor = @shelter.pets.create!(image:"", name: "Thor", description: "dog", approximate_age: 2, sex: "male")
        @bubba = @shelter.pets.create!(image:"", name: "Bubba", description: "dog", approximate_age: 1, sex: "male")
        @Fluffy = @shelter.pets.create!(image:"", name: "Fluffy", description: "dog", approximate_age: 2, sex: "male")
        @FLUFF = @shelter.pets.create!(image:"", name: "FLUFF", description: "dog", approximate_age: 1, sex: "male")
        @MrFlUfF = @shelter.pets.create!(image:"", name: "Mr. FlUfF", description: "dog", approximate_age: 1, sex: "male")
      end
      it 'should return Pets filtered by the give query that partially matches and is case insensitive' do
        result = Pet.filter_by_name('Uf')

        expect(result.length).to eq(3)
      end

      it 'should return an empty array if the query is nil' do
        result = Pet.filter_by_name(nil)
        expect(result).to eq([])
      end
    end
  end

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_presence_of :description}
    it {should validate_presence_of :sex}
    it {should validate_numericality_of(:approximate_age).is_greater_than_or_equal_to(0)}

    it 'is created as adoptable by default' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(name: "Fluffy", approximate_age: 3, sex: 'male', description: 'super cute')
      expect(pet.adoptable).to eq(true)
    end

    it 'can be created as not adoptable' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(adoptable: false, name: "Fluffy", approximate_age: 3, sex: 'male', description: 'super cute')
      expect(pet.adoptable).to eq(false)
    end

    it 'can be male' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(sex: :male, name: "Fluffy", approximate_age: 3, description: 'super cute')
      expect(pet.sex).to eq('male')
      expect(pet.male?).to be(true)
      expect(pet.female?).to be(false)
    end

    it 'can be female' do
      shelter = Shelter.create!(name: 'Pet Rescue', address: '123 Adoption Ln.', city: 'Denver', state: 'CO', zip: '80222')
      pet = shelter.pets.create!(sex: :female, name: "Fluffy", approximate_age: 3, description: 'super cute')
      expect(pet.sex).to eq('female')
      expect(pet.female?).to be(true)
      expect(pet.male?).to be(false)
    end
  end
end
