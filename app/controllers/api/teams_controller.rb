class Api::TeamsController < Api::BaseController

  def index

    teams = Team.all
    render json: teams
  end

  def create
    team = Team.create!(safe_params)
    render json: team
  end

  def destroy
    Team.find(params[:id]).destroy
    render nothing: true
  end

  private

  def safe_params
    params.require(:team).permit(:name)
  end

end