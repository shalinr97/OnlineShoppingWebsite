class AdminController < ApplicationController
  def login
    if request.post?
      admin = Admin.where(userid: params[:userid], password: Digest::SHA256.hexdigest(params[:password])[50])
      if admin.count > 0
        @products = Product.all
        session[:adminuserid] = params[:userid]
        redirect_to "http://localhost:3000/products"
      else
        redirect_to "http://localhost:3000/admin/login", notice: "Unable to Login."
      end
    end
  end

  def logout
    session.delete(:adminuserid)
    redirect_to "http://localhost:3000/admin/login"
  end
end
