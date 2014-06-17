class Api::UsersController < Api::BaseController

  def index
    page = params[:page] || 1
    users = User.paginate(page: page, per_page: 20)
    render json: {
        users: users,
        pagination: {
            current_page: users.current_page,
            total_pages: users.total_pages,
            total_entries: users.total_entries
        }
    }
  end

  private

end