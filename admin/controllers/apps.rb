Admin.controllers :apps do

  get :index do
    @apps = App.all
    render 'apps/index'
  end

  get :new do
    @app = App.new
    render 'apps/new'
  end

  post :create do
    @app = App.new(params[:app])
    if @app.save
      flash[:notice] = 'App was successfully created.'
      redirect url(:apps, :edit, :id => @app.id)
    else
      render 'apps/new'
    end
  end

  get :edit, :with => :id do
    @app = App.find(params[:id])
    render 'apps/edit'
  end

  put :update, :with => :id do
    @app = App.find(params[:id])
    if @app.update_attributes(params[:app])
      flash[:notice] = 'App was successfully updated.'
      redirect url(:apps, :edit, :id => @app.id)
    else
      render 'apps/edit'
    end
  end

  delete :destroy, :with => :id do
    app = App.find(params[:id])
    if app.destroy
      flash[:notice] = 'App was successfully destroyed.'
    else
      flash[:error] = 'Unable to destroy App!'
    end
    redirect url(:apps, :index)
  end
end
