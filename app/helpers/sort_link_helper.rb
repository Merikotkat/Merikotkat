module SortLinkHelper
  def create_link title, column, order

    link_to raw(title), action:"index", type: params[:type], sortby: column, order: order
  end


  def arrow column
    if column == params[:sortby]
      if params[:order] == "asc"
        arrow = " &#9650;"
      else
        arrow = " &#9660;"
      end
      return arrow
    end
    return ""
  end
end
