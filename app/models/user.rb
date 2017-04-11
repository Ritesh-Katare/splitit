class User < ActiveRecord::Base

	has_many :bill_attendees
	has_many :attended_bills, :through => :bill_attendees, :source => :bill

	has_many :bill_payers
	has_many :paid_bills, :through => :bill_payers, :source => :bill

	def total_paid_amount
		amount = 0
		self.bill_payers.each {|paid| (amount = amount + paid.amount)}
		amount
	end

    def is_payee_of bill
        bill.payee_users.to_a.include?(self) ? true : false
    end

	def owed
		self.bill_payers.each {|paid| amount = amount + paid.amount}
	end
end
