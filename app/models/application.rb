class Application < ApplicationRecord
  after_initialize :set_defaults, unless: :persisted?

  has_many :adoptions
  has_many :pets, through: :adoptions

  validates_presence_of :name, :address, :city, :state, :zip

  def set_defaults
    self.status ||= 'In Progress'
  end
end
