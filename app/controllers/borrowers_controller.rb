class BorrowersController < ApplicationController
  before_action :check_authorization, except: [:create]
  def show
    @borrower = Borrower.find_by_id(params[:borrower_id])
    @my_lenders = @borrower.lenders.group(:id)
  end

  def create
    borrower = Borrower.new(borrower_params)
    if(borrower.save)
      flash[:message] = "Successfully created account!"
      redirect_to "/login"
    else
      flash[:errors] = borrower.errors.full_messages
      redirect_to :back
    end
  end

  private
    def borrower_params
      params.require(:borrower).permit(:first_name, :last_name, :email, :password, :reason, :discription, :amount)
    end
    def check_authorization
      if session[:user_type] != "borrower" or session[:user_id].to_s != params[:borrower_id]
        redirect_to "/login"
        flash[:message] = "Unauthorized access!"
      end
    end
end
