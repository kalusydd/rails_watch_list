class Movie < ApplicationRecord
  has_many :bookmarks
  has_many :lists, through: :bookmarks # not sure if I need this...

  validates :title, presence: true, uniqueness: true
  validates :overview, presence: true
end
