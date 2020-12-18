class Pet < ApplicationRecord
  belongs_to :shelter
  has_many :adoptions
  has_many :applications, through: :adoptions

  validates_presence_of :name, :description, :approximate_age, :sex
  validates_uniqueness_of :name, {case_sensitive: false}
  validates :approximate_age, numericality: {
              greater_than_or_equal_to: 0
            }

  enum sex: [:female, :male]

  def self.filter_by_name(query)
    if query.nil?
      return [];
    else
      where('lower(name) like ?', "%#{query.downcase}%")
    end
  end
end
