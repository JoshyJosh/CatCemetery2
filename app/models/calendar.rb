class Calendar < ActiveRecord::Base
	belongs_to :customer
	validates :customer_id, presence: true
	validates :res_date, uniqueness: true
	
end
