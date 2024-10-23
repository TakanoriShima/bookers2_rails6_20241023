class BooksController < ApplicationController
  # protect_from_forgery
  # skip_before_action :verify_authenticity_token
  def index
    @user = current_user
    @book = Book.new
    @books = Book.all
    @errors = session[:book_error]
    if@errors == nil
      @errors = []
    end
    session[:book_error] = nil
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:success] = 'You have created book successfully.';
      redirect_to @book
    else
      session[:book_error] = @book.errors.full_messages
      redirect_to books_path
    end
  end  

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    if session[:book_error]
      @errors = session[:book_error]
      session[:book_error] = nil
      render :edit
    else
      #@errors = nil
    end
  end

  def edit
    @book = Book.find(params[:id])
    unless @book.user.id == current_user.id
      redirect_to books_path
    end
    @errors = []
  end
  
  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:success] = 'You have updated book successfully.'
      redirect_to @book
    else
      session[:book_error] = @book.errors.full_messages
      redirect_to @book
    end  
  end  
  
  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end  
  
  private
  
  def book_params
    params.require(:book).permit(:title, :body)
  end
end
