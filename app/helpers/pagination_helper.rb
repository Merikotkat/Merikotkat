module PaginationHelper
  def create_pagination_link title, page, sortby, order
    link_to title, action:"index", type: params[:type], page: page, sortby: sortby, order: order
  end
end