require 'securerandom'
require 'digest'

class ShopperController < ApplicationController
  def index
    if session[:userid] != nil and session[:userid] != ""
      if params[:search] == "Search" and params[:searchField] != ""
        @products = Product.where("description LIKE ? or name LIKE ?","%" + params[:searchField] + "%","%" + params[:searchField] + "%")
        @userCart = Cart.where(userId: session["userid"])
        @orders = Order.where(userId: session["userid"])
        @orderIds = Array.new
        @orders.each do |o|
          @orderIds.append(o.orderid)
        end
        @orderIds.uniq!
      else
        if (params[:logout] == "Logout")
          redirect_to "http://localhost:3000/shopper/logout"
        end
        if (params[:reviewCart] == "Review Cart")
          redirect_to "http://localhost:3000/shopper/cart"
        end
        if (params[:emptyCart] == "Empty Cart")
          Cart.where(userId: session["userid"]).destroy_all
        end
        if (params[:productName] == nil and params[:cartItemProductName] == nil)
          @products = Product.all
          @userCart = Cart.where(userId: session["userid"])
          @orders = Order.where(userId: session["userid"])
          @orderIds = Array.new
          @orders.each do |o|
            @orderIds.append(o.orderid)
          end
          @orderIds.uniq!
        elsif (params[:productName] != nil)
          cartRecord = Cart.where(userId: session["userid"], productName:params[:productName])
          if cartRecord.count == 0
            cartObject = Cart.new
            cartObject.userId = session[:userid]
            cartObject.productName = params[:productName]
            cartObject.cost = params[:cost]
            cartObject.quantity = 1
            cartObject.save
          else
            cartObject = Cart.find_by(userId: session["userid"], productName:params[:productName])
            cartObject.quantity = cartObject.quantity + 1
            cartObject.cost = cartObject.cost + params[:cost].to_f
            cartObject.save
          end
          @products = Product.all
          @userCart = Cart.where(userId: session["userid"])
          @orders = Order.where(userId: session["userid"])
          @orderIds = Array.new
          @orders.each do |o|
            @orderIds.append(o.orderid)
          end
          @orderIds.uniq!
        elsif (params[:cartItemProductName] != nil)
          productObject = Product.find_by(name: params[:cartItemProductName])
          if (params[:addItem] == "+")
            cartObject = Cart.find_by(userId: session["userid"], productName:params[:cartItemProductName])
            cartObject.quantity = cartObject.quantity + 1
            cartObject.cost = cartObject.cost + productObject.price
            cartObject.save
          elsif (params[:removeItem] == "-")
            cartObject = Cart.find_by(userId: session["userid"], productName:params[:cartItemProductName])
            if (cartObject.quantity == 1)
              Cart.where(userId: session["userid"], productName:params[:cartItemProductName]).destroy_all
            else
              cartObject.quantity = cartObject.quantity - 1
              cartObject.cost = cartObject.cost - productObject.price
              cartObject.save
            end
          end
          @products = Product.all
          @userCart = Cart.where(userId: session["userid"])
          @orders = Order.where(userId: session["userid"])
          @orderIds = Array.new
          @orders.each do |o|
            @orderIds.append(o.orderid)
          end
          @orderIds.uniq!
        end
      end
    else
      redirect_to "http://localhost:3000/401"
    end
  end

  def login
    if request.post?
      shoppers = Shopper.where(userid: params[:userid], password: Digest::SHA256.hexdigest(params[:password])[50])
      if shoppers.count > 0
        @products = Product.all
        session[:userid] = params[:userid]
        redirect_to "http://localhost:3000/shopper/index"
      else
        redirect_to "http://localhost:3000/shopper/login", notice: "Login failed."
      end
    end
  end

  def logout
    session.delete(:userid)
    redirect_to "http://localhost:3000/shopper/login"
  end

  def new
    if request.post?
      shopper = Shopper.new
      shopper.userid = params[:userid]
      shopper.name = params[:name]
      shopper.password = Digest::SHA256.hexdigest(params[:password])[50]
      shopper.email = params[:email]
      shopper.save
      redirect_to "http://localhost:3000/shopper/login", notice: "Registration is successful."
    end
  end

  def cart
    if params[:back] == "<- Back"
      redirect_to "http://localhost:3000/shopper/index"
    end
    if params[:placeOrder] == "Place Order"
      session["creditCardNo"] = params[:creditCardNo]
      session["address"] = params[:address]
      session["name"] = params[:name]
      redirect_to "http://localhost:3000/shopper/order", notice: "Order placed successfully"
    end
    @userCart = Cart.where(userId: session["userid"])
  end

  def order
    userCart = Cart.where(userId: session["userid"])
    generatedOrderId = "order-#{SecureRandom.hex}"
    userCart.each do |cartItem|
      order = Order.new
      order.orderid = generatedOrderId
      order.userid = session[:userid]
      order.productName = cartItem.productName
      order.quantity = cartItem.quantity
      order.price = cartItem.cost
      order.creditCardNo = session["creditCardNo"]
      order.address = session["address"]
      order.name = session["name"]
      order.save
    end
    session.delete(:creditCardNo)
    session.delete(:address)
    session.delete(:name)
    Cart.where(userId: session["userid"]).destroy_all
    redirect_to "http://localhost:3000/shopper/index", notice: 'Order successfully created.'
  end

end
