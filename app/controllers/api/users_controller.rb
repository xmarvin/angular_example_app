class Api::UsersController < Api::BaseController

  def index
    page = params[:page] || 1
    q = params[:q] || ''
    search = User.search do
      fulltext q
      paginate page: page, per_page: 20
    end.results
    render json: {
        users: search,
        pagination: {
            current_page: search.current_page,
            total_pages: search.total_pages,
            total_entries: search.total_entries
        }
    }
  end

  private

end