class SearchesController < ApplicationController
  #ユーザがログインしているかどうかを確認し、ログインしていない場合はユーザをログインページにリダイレクト
  before_action :authenticate_user!

  def search
    #検索フォームからの情報を受け取り
    #検索モデル →params[:range]
    @range = params[:range]
    # if文を使い、検索モデルUser or Bookで条件分岐
    if @range == "User"
      #検索方法→params[:search] 検索ワード→params[:word]
      @users = User.looks(params[:search],params[:word])
      render  'searches/search_result'
      #looksメソッドを使い、検索内容を取得し、変数に代入
      #検索方法params[:search]と、検索ワードparams[:word]を参照してデータを検索し、
      #1インスタンス変数@usersにUserモデル内での検索結果を代入
      #2インスタンス変数@booksにBookモデル内での検索結果を代入
    else
      @books = Book.looks(params[:search],params[:word])
      render  'searches/search_result'
    end
  end
end
