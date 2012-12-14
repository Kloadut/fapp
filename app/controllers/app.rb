Fapp.controllers :app do

    get :list do
        @apps = App.all(:order => 'created_at desc')
        render 'app/list'
    end

    get :show, :with => :id do
        @app = App.find_by_id(params[:id])
        render 'app/show'
    end

    get :new do
        captcha_create
        render 'app/new'
    end

    post :new do
        captcha_validate
        @app = App.new(params[:post])
        logger.info params
        if @app.save
            flash[:notice] = t "App was successfully created."
            redirect url(:app, :list)
        else
            flash[:warning] = t "An error occurred during App creation."
            redirect url(:app, :new)
        end
    end

end
