require 'rails_helper'

describe Adoption do
  describe 'relationships' do
    it {should belong_to :application}
    it {should belong_to :pet}
  end
end
