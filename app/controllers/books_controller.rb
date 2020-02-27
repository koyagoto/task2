class BooksController < ApplicationController

  before_action :authenticate_user!,except: [:about,:top]

  def show
  	@books = Book.find(params[:id])
    @user = User.find(@books.user_id)
    @book = Book.new
  end

  def index
  	@books = Book.all
    @book = Book.new #一覧表示するためにBookモデルの情報を全てくださいのall
  end

  def create
  	@book = Book.new(book_params)
    @book.user_id = current_user.id #Bookモデルのテーブルを使用しているのでbookコントローラで保存する。
  	if @book.save #入力されたデータをdbに保存する。
  		 redirect_to book_path(@book.id), notice: "successfully created book!"#保存された場合の移動先を指定。
  	else
       flash.now[:alert] = 'error'
  		 @books = Book.all
  		 render 'index'
  	end
  end

  def edit
  	@book = Book.find(params[:id])
    if @book.user_id == current_user.id
       render :edit
     else
      redirect_to books_path
  end
end



  def update
  	 @book = Book.find(params[:id])
  	 @book.update(book_params)
     if @book.save
  		  redirect_to book_path(@book), notice: "successfully updated book!"
  	 else #if文でエラー発生時と正常時のリンク先を枝分かれにしている。
      @user = current_user
      @books = Book.all
      flash.now[:alert] = 'error'
  		render "edit"
  	 end
  end

  def destroy
  	book = Book.find(params[:id])
  	book.destroy
  	redirect_to books_path, notice: "successfully delete book!"
  end

  private

  def book_params
  	params.require(:book).permit(:title,:body,:user_id)
  end

end
