class PropertiesController < ApplicationController
  get '/properties/:id' do
    @property = Property.find(params[:id])
    if is_logged_in? && (@property.item.share == "private" && !current_user.items.include?(@property.item))
      redirect '/users'
    elsif @property.item.share == "private"
      redirect '/'
    else
      erb :'/properties/show'
    end
  end

  get '/properties/:id/edit' do
    redirect_if_not_logged_in
  
    @error_message = params[:error] 
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

    property.update(params["property"])

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
