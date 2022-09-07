class BookCommentsController < ApplicationController

  def create
    @book = Book.find(params[:book_id])
    @comment = current_user.book_comments.new(book_comment_params)
    @comment.book_id = @book.id
    @comment.save
    #redirect_to request.referer
    #render :book_comments
  end

  def destroy
    @comment = BookComment.find(params[:id])
    @comment.destroy
    #@book = Book.find(params[:book_id])
    #book_comment = @book.book_comments.find (params[:id])
    #book_comment.destroy
    #redirect_to request.referer
    #render :book_comments
  end

  private
  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end



