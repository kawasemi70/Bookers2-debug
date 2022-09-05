class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments,dependent: :destroy
  has_many :favorites,dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end


  #検索機能方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?", "#{word}")
      #titleは検索対象であるbooksテーブル内のカラム名
      #このコードはBookモデルから検索ワードにヒットしているかを確認するコード
    elsif search == "forard_match"
      @book = Book.where("title LIKE?", "#{word}")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?", "#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?", "#{word}")
    else
      @book = Book.all
    end
    #各検索方法を_serach.html.erbの検索フォームと同じにする
    #完全一致→perfect_match
    #前方一致→forward_match
    #後方一致→backword_match
    #部分一致→partial_match

    #送られてきたsearchによって条件分岐させる
    #whereメソッドを使いデータベースから該当データを取得し、変数に代入
    #完全一致以外の検索方法は、
    #{word}の前後(もしくは両方に)、__%__を追記することで定義することができる
    #これにより、検索方法毎に適した検索が行われる


  end
end
