Admin.controllers :sessions do

  get :new do
    render "/sessions/new", nil, :layout => false
  end

  post :create do
    if account = User.authenticate(params[:nick], params[:password])
      set_current_account(account)
      redirect url(:base, :index)
    elsif Padrino.env == :development && params[:bypass]
      account = User.first
      set_current_account(account)
      redirect url(:base, :index)
    else
      params[:nick], params[:password] = h(params[:nick]), h(params[:password])
      flash[:warning] = "Login or password wrong."
      redirect url(:sessions, :new)
    end
  end

  delete :destroy do
    set_current_account(nil)
    redirect url(:sessions, :new)
  end
end
