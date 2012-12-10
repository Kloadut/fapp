Fapp.controllers :app do
    get :list do
        @apps = App.all(:order => 'created_at desc')
        render 'app/list'
    end

    get :show, :with => :id do
        @app = App.find_by_id(params[:id])
        render 'app/show'
    end

    get '/app/new' do
        render 'app/new'
    end

    post :new do
        # TODO: Verify captcha
        # TODO: Compute inputs
        redirect to('/app/list')
    end
end
