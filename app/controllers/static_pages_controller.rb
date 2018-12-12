class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost = current_user.microposts.build
    @feed_items = current_user.microposts.newest.paginate page: params[:page],
      per_page: Settings.users.page_items_count
  end

  def help; end

  def about; end

  def contact; end
end
