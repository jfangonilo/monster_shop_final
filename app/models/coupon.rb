class Coupon < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :code
  validates_presence_of :percent_off

  validates_uniqueness_of :name
  validates_uniqueness_of :code

  validates_numericality_of :percent_off, greater_than: 0, less_than: 1

  belongs_to :merchant
end