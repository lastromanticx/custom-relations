class PropertiesController < ApplicationController
  get '/properties/:id' do
    redirect_if_not_logged_in

    @property = Property.find(params[:id])
    if @property.item.share == "private" && @property.item.user != current_user
      redirect '/users'
    end
    
    erb :'/properties/show'
  end
end
