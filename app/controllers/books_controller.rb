class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book, only: [:edit, :update, :destroy]
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "Book created successfully"
      redirect_to book_path(@book)
    else
      @books = Book.all
      @user = current_user
      flash.now[:alert] = "Book creation error"
      render :index
    end
  end

  def index
    @books = Book.all
    @book = Book.new
    @user = current_user
  end

  def show
    @book = Book.find(params[:id])
    @books = [@book]
    @user = @book.user
    @book_new = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end
  
  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "Book updated successfully"
      redirect_to book_path(@book)
    else
      flash.now[:alert] = "Book update error"
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      flash[:alert] = "Access error: You can't edit others' books"
      redirect_to books_path
    end
  end

  def set_book
    @book = Book.find(params[:id])
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :image)
  end
end
