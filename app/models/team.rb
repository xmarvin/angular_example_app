class Team < ActiveRecord::Base
  has_many :team_members, dependent: :destroy
  has_many :users, source: :user, through: :team_members

  def as_json(attrs = {})
    super methods: [:team_members_length]
  end

  def team_members_length
    team_members.count
  end

end
