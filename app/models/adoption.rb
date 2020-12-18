class Adoption < ApplicationRecord
  belongs_to :application
  belongs_to :pet
end
