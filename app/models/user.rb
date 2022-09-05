class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :book_comments,dependent: :destroy
  has_many :favorites, dependent: :destroy

  # フォローするユーザーから見た中間テーブル
  # foreign_key（FK）には、@user.xxxとした際に「@user.idがfollower_idなのかfollowed_idなのか」を指定します。
  has_many :active_relationships, class_name: "Relationship",
                                   foreign_key: "follower_id",
                                   dependent: :destroy
                                   #inverse_of: :follower
   # フォローされているユーザーから見た中間テーブル
  has_many :passive_relationships, class_name: "Relationship",
                                      foreign_key: "followed_id",
                                      dependent: :destroy
                                     # inverse_of: :following

  # 一覧画面で使う
  # @user.booksのように、@user.yyyで、
  # そのユーザがフォローしている人orフォローされている人の一覧を出したい
  # 中間テーブルactive_relationshipsを通って、フォローされる側(followed)を集める処理をfollowingsと命名
  has_many :followings, through: :active_relationships,source: :followed
  # followersを通じてfollowingにたどり着く
  # 中間テーブルpassive_relationshipsを通って、フォローする側(follower)を集める処理をfollowingsと命名
  has_many :followers, through: :passive_relationships,source: :follower
  # followingsを通じてfollowerにたどり着く

  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50}




  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  # フォローする
  def follow(user_id)
    active_relationships.create(followed_id: user_id)
  end
  # フォロー解除する
  def unfollow(user_id)
    active_relationships.find_by(followed_id: user_id).destroy
  end
  # フォローしているか確認
  def following?(user)
    followings.include?(user)
  end


  #検索機能方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
      #nameは検索対象であるusersテーブル内のカラム名
      #このコードはUserモデルから検索ワードにヒットしているかを確認するコード
    elsif search == "forard_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "backward_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?", "#{word}")
    else
      @user = User.all
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
