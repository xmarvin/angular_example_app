class TeamMember < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  validates :user_id, uniqueness: { scope: [:team_id] }

  def as_json(attrs={})
    super include: :user
  end
end
