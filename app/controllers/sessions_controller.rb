class SessionsController < ApplicationController
  def new
  end

  def create
    user = Borrower.find_by_email(params[:user][:email])
    borrower = true
    err = true
    unless user
      user = Lender.find_by_email(params[:user][:email])
      borrower = false
    end

    if user
      if user.authenticate(params[:user][:password])
        session[:user_id] = user.id
        if(borrower)
          session[:user_type] = "borrower"
        else
          session[:user_type] = "lender"
        end
        err = false
      else
        flash[:errors] = ["Wrong password"]
      end
    else
      flash[:errors] = ["Wrong email"]
    end
    if err
      redirect_to "/login"
    else
      if session[:user_type] == "borrower"
        redirect_to "/borrowers/#{user.id}"
      else
        redirect_to "/lenders/#{user.id}"
      end
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_type] = nil
    redirect_to "/login"
  end
end
