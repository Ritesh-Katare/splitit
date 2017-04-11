class Bill < ActiveRecord::Base
	has_many :bill_attendees, dependent: :destroy
	has_many :attended_users, :through => :bill_attendees, :source => :user

	has_many :bill_payers, dependent: :destroy
	has_many :payee_users, :through => :bill_payers, :source => :user

  accepts_nested_attributes_for :bill_payers,
    :reject_if => :all_blank,
    :allow_destroy => true

    def self.all_bills_total
        amount = 0
        Bill.all.each {|b| amount = amount + b.amount }
        amount
    end

    def total_participants
    	self.bill_attendees.count
    end

    def participants
        participants = []
    	self.bill_attendees.each {|p| participants << p.user }
        participants
    end

    def payers
        self.bill_payers
    end

    def responsible_amount
    	(self.amount.to_f / self.total_participants.to_f)
    end

    def is_paid_by user
        true if self.payee_users.find_by_id user
    end

    def paid_by user
        payee = self.bill_payers.find_by_user_id user
        payee.present? ? paid = payee.amount : paid = 0
    end

    def owed_by user
        owe = self.responsible_amount - (self.paid_by user)
        owe < 0 ? 0 : owe
    end

    def calculate
        
    end

#    def bill_difference
#        @amount_paid - @amount_should_have_paid
#    end

end
