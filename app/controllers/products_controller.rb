class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    if session[:adminuserid] != "" and session[:adminuserid] != nil
      @products = Product.all
    else
      redirect_to "http://localhost:3000/401"
    end

  end

  # GET /products/1 or /products/1.json
  def show
    if session[:adminuserid] == "" or session[:adminuserid] == nil
      redirect_to "http://localhost:3000/401"
    end
  end

  # GET /products/new
  def new
    if session[:adminuserid] == "" or session[:adminuserid] == nil
      redirect_to "http://localhost:3000/401"
    end
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
    if session[:adminuserid] == "" or session[:adminuserid] == nil
      redirect_to "http://localhost:3000/401"
    end
  end

  # POST /products or /products.json
  def create
    if session[:adminuserid] == "" or session[:adminuserid] == nil
      redirect_to "http://localhost:3000/401"
    end
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    if session[:adminuserid] == "" or session[:adminuserid] == nil
      redirect_to "http://localhost:3000/401"
    end
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    if session[:adminuserid] == "" or session[:adminuserid] == nil
      redirect_to "http://localhost:3000/401"
    end
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :description, :price, :image)
    end
end
