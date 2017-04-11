class BillsController < ApplicationController
 before_action :get_bill, only: [:show, :edit, :update, :destroy]

	def index
		@bills = Bill.all
		@users = User.all
		@bills_total = Bill.all_bills_total
		@share = @bills_total.to_f / 3

		@amar_to_akbar = 0
		@amar_to_anthony = 0
		@akbar_to_amar = 0
		@akbar_to_anthony = 0
		@anthony_to_amar = 0
		@anthony_to_akbar = 0

		@bills.each do |bill|
			share = bill.responsible_amount

 			bill.participants.each do |usr|
 			  due = share - (bill.paid_by usr)
			  if due > 0
 				if usr.name == 'Amar'
 					@amar_to_akbar += (bill.paid_by User.second).to_f / bill.total_participants.to_f if (User.second).is_payee_of bill
# 					@amar_to_akbar += due if (User.second).is_payee_of bill if (User.second).is_payee_of bill
 					@amar_to_anthony += (bill.paid_by User.third).to_f / bill.total_participants.to_f if (User.third).is_payee_of bill
 				end
 				if usr.name == 'Akbar'
 					@akbar_to_amar += (bill.paid_by User.first).to_f / bill.total_participants.to_f if (User.first).is_payee_of bill
 					@akbar_to_anthony += (bill.paid_by User.third).to_f / bill.total_participants.to_f if (User.third).is_payee_of bill
 				end
 				if usr.name == 'Anthony'
 					@anthony_to_amar += (bill.paid_by User.first).to_f / bill.total_participants.to_f if (User.first).is_payee_of bill
 					@anthony_to_akbar += (bill.paid_by User.second).to_f / bill.total_participants.to_f if (User.second).is_payee_of bill
 				end
 			  end
 			end
		end
		render :index
	end

	def show
	end

	def new
		@bill = Bill.new
		render :new
	end

	def create
		@bill = Bill.new billing_params

		bill_params[:bill_attendees].each do |user_id|
			@bill.bill_attendees.build(user_id: user_id)
		end

		bill_params[:bill_payers].each do |payee, paid|
			user_id = User.where(name: payee).first.id
			@bill.bill_payers.build(user_id: user_id, amount: paid) if paid.present? or paid == 0
		end

		if @bill.save!
		    respond_to do |format|
		      format.html { redirect_to bills_path, notice: 'Bill was successfully added.' }
		      format.json { head :no_content }
		    end
		else
			flash[:notice] = "Error with your bill."
			render :new
		end
	end

	  def destroy
	    @bill.destroy
	    respond_to do |format|
	      format.html { redirect_to bills_path, notice: 'Bill was successfully deleted.' }
	      format.json { head :no_content }
	    end
	  end


  	def billing_params
    	bill_params.except(:bill_attendees, :bill_payers)
  	end

private

   def get_bill
    @bill = Bill.find(params[:id])
   end

  def bill_params
    params.require(:bill).permit(:event, :entry_date, :location, :amount, :bill_attendees =>[], :bill_payers => [:amar, :akbar, :anthony])
  end
end
