# frozen_string_literal: true

ActiveAdmin.register Place do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :address, :score, :description, :category_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :address, :score, :description, :category_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
