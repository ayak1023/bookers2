class BooksController < ApplicationController


  def index
    @books = Book.all
    @book_new = Book.new
  end

  def show
    @book_new = Book.new
    @book = Book.find(params[:id])
  end

  def edit
    @book = Book.find(params[:id])
  end

  def create
    @book_new = Book.new(book_params)
    @book_new.user_id = current_user.id
    if @book_new.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book_new.id)#fix
    else
      @books = Book.all  # エラー時に書籍一覧を再度取得する
      render :index
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(book.id)
    else
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  private
  def book_params
    params.require(:book).permit(:title, :body)
  end

  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user.id == current_user.id
      redirect_to books_path
    end
  end

end
