class PropertiesController < ApplicationController
  get '/properties/:id' do
    redirect_if_not_logged_in

    @property = Property.find(params[:id])
    if @property.item.share == "private" && @property.item.user != current_user
      redirect '/users'
    end
    
    erb :'/properties/show'
  end

  get '/properties/:id/edit' do
    redirect_if_not_logged_in
  
    @property = Property.find(params[:id])

    if @property.item.share != "edit" && !current_user.items.include?(@property.item)
      redirect '/users'
    end

    erb :'/properties/edit'
  end

  patch '/properties/:id' do
    property = Property.find(params[:id])

    if params[:property][:name].match(/^\s*$/)
      redirect "/properties/#{property.id}/edit?error=Please name the property."
    end

    property.update(params[:property])

    item = property.item
    redirect "/items/#{item.id}/edit"
  end

  get '/properties/:id/delete' do
    redirect_if_not_logged_in

    property = Property.find(params[:id])

    if property.item.share != "edit" && !current_user.items.include?(property.item)
      redirect '/users'
    end
    
    item = property.item
    property.destroy

    redirect "/items/#{item.id}/edit"
  end
end
