class Recipe < ApplicationRecord
  validates :title, :cook_time, :difficulty, presence: true
end
