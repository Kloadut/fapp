Fapp.helpers do
    def captcha_create
        session[:ip] = request.env["REMOTE_ADDR"]
        session[:captcha1] = Random.rand(42)
        session[:captcha2] = Random.rand(42)
        @captcha = '<input type="hidden" id="captcha1" name="captcha1" value="'+ session[:captcha1].to_s()  +'">
                    <input type="hidden" id="captcha2" name="captcha2" value="'+ session[:captcha2].to_s()  +'">'
    end

    def captcha_validate
        params[:captcha] && session[:ip] == request.env["REMOTE_ADDR"] && params[:captcha] == (session[:captcha1] + session[:captcha2]).to_s()
    end
end
