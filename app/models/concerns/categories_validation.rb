module CategoriesValidation
  def categories_validation
    valid_categories = Category.all.pluck(:name)
    unless category_list.all? { |category| valid_categories.include?(category) }
      fail "One or more categories are invalid"
    end
  end
end
