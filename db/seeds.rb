# Seed add you the ability to populate your db.
# We provide you a basic shell for interaction with the end user.
# So try some code like below:
#
#   name = shell.ask("What's your name?")
#   shell.say name
#
nick      = shell.ask "Which nick do you want use for logging into admin?"
email     = shell.ask "Gimme gimme gimme an email:"
password  = shell.ask "Tell me the password to use:"
app       = shell.ask "Do you want to additionally create a sample App ? (yes/NO)"

shell.say ""

account = User.create(:email => email, :nick => nick, :password => password, :password_confirmation => password, :role => 'admin')

if account.valid?
  shell.say "================================================================="
  shell.say "Account has been successfully created, now you can login with:"
  shell.say "================================================================="
  shell.say "   nick: #{nick}"
  shell.say "   password: #{password}"
  shell.say "================================================================="
else
  shell.say "Sorry but some thing went wrong!"
  shell.say ""
  account.errors.full_messages.each { |m| shell.say "   - #{m}" }
end

if  app == "y" ||
    app == "yes" ||
    app == "true" ||
    app == "oui" ||
    app == "o"

    sample_app = App.create(:app_id                        => "sample." + nick,
                            :author_email                  => email,
                            :author_password               => password,
                            :author_password_confirmation  => password,
                            :name                          => "SamplApp",
                            :git_url                       => "https://github.com/TibshoOT/fapp",
                            :git_branch                    => "master",
                            :git_commit                    => "171a708261cdf22dca4b3cfddce509be73a81b89")

    if sample_app
        shell.say "================================================================="
        shell.say "Sample App has been successfully created"
        shell.say "================================================================="
    else
        shell.say "Sorry but some thing went wrong!"
        shell.say ""
        account.errors.full_messages.each { |m| shell.say "   - #{m}" }
    end
end

shell.say ""
