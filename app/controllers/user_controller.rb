# -*- encoding: utf-8 -*-
class UserController < ApplicationController
  
  def index
    list
    render :action => 'list'
  end



  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @user_pages, @users = paginate(:users, :per_page => 50, :conditions => ["deleted = 0", 1])
  end

  def fixmessage
    session[:msgids] ||= ""
    session[:msgids] = (session[:msgids].split(",") << params[:id]).uniq.join(",")
    respond_to do |format|
      format.js {render :text => ";"}
    end
  end

end
