class User < ActiveRecord::Base
  devise :token_authenticatable, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_many :task_lists, foreign_key: :owner_id

  def clear_authentication_token!
    update_attribute(:authentication_token, nil)
  end

  def first_list
    task_lists.first
  end
end
