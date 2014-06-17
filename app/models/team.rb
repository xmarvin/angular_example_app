class Team < ActiveRecord::Base
  has_many :team_members, dependent: :destroy
  has_many :users, source: :user, through: :team_members
end
