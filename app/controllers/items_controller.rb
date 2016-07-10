class ItemsController < ApplicationController
  get '/items/new' do
    redirect_if_not_logged_in
    @error_message = params[:error]
    erb :'/items/new'
  end

  post '/items' do
    if params[:item][:name].match(/^\s*$/)
      redirect '/items/new?error=Please name the item.'
    end

    item = Item.create(params[:item])

    current_user.items << item 
    if !params[:property][:name].match(/^\s*$/)
      item.properties << Property.create(params[:property])
    end

    redirect "/items/#{item.id}"
  end

  get '/items/:id' do
    @item = Item.find(params[:id])
    if @item.share == "private"
      if is_logged_in? && current_user.items.include?(@item)
        erb :'/items/show'
      else
        redirect '/'
      end
    else
      erb :'/items/show'
    end
  end

  get '/items/:id/edit' do
    redirect_if_not_logged_in
    
    @error_message = params[:error]
    @item = Item.find(params[:id])

    if @item.share != "edit" && !current_user.items.include?(@item)
      redirect "/items/#{params[:id]}"
    end

    erb :'/items/edit'
  end

  patch '/items/:id' do
    @item = Item.find(params[:id])

    if params[:item][:name].match(/^\s*$/)
      redirect "/items/#{@item.id}/edit?error=Please name the property."
    end

   @item.update(params["item"])

    if !params[:property][:name].match(/^\s*$/)
      @item.properties << Property.create(params[:property])
    end

    erb :'/items/show'
  end

  get '/items/:id/delete' do 
   redirect_if_not_logged_in  
              
    item = Item.find(params[:id])

    if item.share != "edit" && !current_user.items.include?(item)
      redirect '/users'        
    end
                
    user = item.user
    item.properties.each(&:destroy)
    item.destroy  
                        
    redirect "/users/#{user.username}"
  end
end
