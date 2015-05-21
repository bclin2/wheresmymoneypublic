require 'will_paginate/array'

class ContactsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @users_from_search_results = User.search(params[:search])
    @contacts = @user.contacts.reject{|contact| contact.results.count<=0}
    @contacts = @users_from_search_results & @contacts
    @contacts = @contacts.sort_by {|contact| contact.results.count}.reverse.paginate(:page => params[:page], :per_page => 10)
  end
end
