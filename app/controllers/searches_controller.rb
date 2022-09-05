class SearchesController < ApplicationController
  #ユーザがログインしているかどうかを確認し、ログインしていない場合はユーザをログインページにリダイレクト
  before_action :authenticate_user!

	def search
		@model = params[:model]
		@content = params[:content]
		@method = params[:method]
		if @model == 'user'
			@records = User.search_for(@content, @method)
		else
			@records = Book.search_for(@content, @method)
		end
	end
end
#検索対象はmodel、検索ワードはcontent、検索方法はmethod

#検索フォームで入力、選択された値をparamsで受け取って@~に代入
#paramsは、フォームなどによって送られてきた情報（パラメーター）を取得するメソッド
#その後に、@modelの値がuserだった場合と、bookだった場合で if文を使い条件分岐
#そしてインスタンス変数　@recordsに入れているのはUser, Bookそれぞれの検索ワード、方法の結果を代入