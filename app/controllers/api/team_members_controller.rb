class Api::TeamMembersController < Api::BaseController

  before_filter :load_team

  def index
    team_members =  @team.team_members
    render json: team_members
  end

  def create
    team_member = @team.team_members.create(safe_params)
    if team_member.persisted?
      render json: team_member
    else
      render json: team_member.errors.full_messages, status: 400
    end

  end

  def destroy
    TeamMember.find(params[:id]).destroy
    render nothing: true
  end

  private

  def load_team
    @team = Team.find(params[:team_id])
  end

  def safe_params
    params.require(:team_member).permit(:user_id)
  end

end