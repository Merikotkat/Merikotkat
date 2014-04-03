module SortLinkHelper
  def create_link title, column
    if params[:order] == "asc"
      order = "desc"
    else
      order = "asc"
    end
    link_to raw(title + arrow(column)), action:"index", type: params[:type], sortby: column, order: order
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
