class User < ActiveRecord::Base
  devise :token_authenticatable, :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_many :team_members
  has_many :teams, source: :team, through: :team_members
  has_many :reviews

  def as_json(attrs = {})
    super include: [:reviews]
  end

  def clear_authentication_token!
    update_attribute(:authentication_token, nil)
  end

  def first_list
    task_lists.first
  end

  searchable do
    text :name, :grade, :position
    integer :age
  end

end
