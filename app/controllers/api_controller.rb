class ApiController < ApplicationController
  skip_before_filter :login_required

  before_filter :api_auth_required, :except => [:error]

  def api_auth_required
    if logged_in?
      return true
    elsif params[:login] == 'goldrush' && params[:password] == 'furuponpon'
      return true
    else
      redirect_to :action => :error
      return false
    end
  end

  def error
    render :text => 'REQUEST ERROR!!'
  end

  #-----------------------------------------------------------------------------
  # API Start
  #-----------------------------------------------------------------------------

  # SES��񃁁[������荞�ޏ������Ăяo��
  def import_mail
    ImportMail.import
    render :text => 'REQUEST OK!'
  end

end
