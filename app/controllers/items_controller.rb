class ItemsController < ApplicationController
  get '/items/new' do
    redirect_if_not_logged_in
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
    redirect_if_not_logged_in
    
    @item = Item.find(params[:id])
    if @item.share == "private" && !current_user.items.include?(@item)
      redirect '/users'
    else
      erb :'/items/show'
    end
  end
end
