module ApplicationHelper
  def sort_asc(column_to_be_sorted)
    link_to "▲", { column: column_to_be_sorted, direction: "asc", word: params[:word] }
  end

  def sort_desc(column_to_be_sorted)
    link_to "▼", { column: column_to_be_sorted, direction: "desc", word: params[:word] }
  end

  def sort_direction
    %W(asc desc).include?(params[:direction]) ? params[:direction] : "asc"
  end
end
