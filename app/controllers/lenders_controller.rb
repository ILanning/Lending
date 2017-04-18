class LendersController < ApplicationController
  before_action :check_authorization, except: [:new, :create]
  def new
    render "register"
  end

  def create
    lender = Lender.new(lender_params)
    if(lender.save)
      flash[:message] = "Successfully created account!"
      redirect_to "/login"
    else
      flash[:errors] = lender.errors.full_messages
      redirect_to :back
    end
  end

  def show
    @lender = Lender.find_by_id(params[:lender_id])
    @needy_borrowers = Borrower.joins(:agreements).group("id").select('borrowers.*, SUM(agreements.amount) AS money_collected')
    @my_borrowers = @lender.borrowers.group("id")
  end

  def lend
    params[:agreement][:lender_id] = params[:lender_id]
    agreement = Agreement.new(agreement_params)
    if agreement.save
      flash[:message] = "Money lent!"
    else
      flash[:errors] = agreement.errors.full_messages
    end
    redirect_to :back
  end

  private
    def lender_params
      params.require(:lender).permit(:first_name, :last_name, :email, :password, :money)
    end
    def agreement_params
      params.require(:agreement).permit(:borrower_id, :lender_id, :amount)
    end
    def check_authorization
      if session[:user_type] != "lender" or session[:user_id].to_s != params[:lender_id]
        redirect_to "/login"
        flash[:message] = "Unauthorized access!"
      end
    end
end
