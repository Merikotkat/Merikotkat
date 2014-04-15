module SortLinkHelper
  def create_link title, column, order
    link_to raw(title), action:"index", type: params[:type], sortby: column, order: order
  end
end
