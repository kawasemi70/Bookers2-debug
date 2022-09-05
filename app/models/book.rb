class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments,dependent: :destroy
  has_many :favorites,dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # #検索機能方法分岐
  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      #titleは検索対象であるbooksテーブル内のカラム名
      #このコードはBookモデルから検索ワードにヒットしているかを確認するコード
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end
end
    #各検索方法を_form.html.erbの検索フォームと同じにする
    #完全一致→perfect
    #前方一致→forward
    #後方一致→backword
    #部分一致→partial
    #送られてきたmethodによって条件分岐させる
    #whereメソッドを使いデータベースから該当データを取得し、変数に代入


