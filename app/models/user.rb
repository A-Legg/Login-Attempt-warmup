class User < ActiveRecord::Base

  validates_presence_of :email, :password
  validates_uniqueness_of :email


  def login_attempt_counter
    #everytime there is a bad login attempt update the counter in the sessions database
    logins = 0
    if login_fail
      logins += 1

    else
      erase_logins
    end
    logins
  end

  def check_user_logins
   #when there is a bad attempt, check the sessions db to see if they have reached the maximum
    if login_fail && login_attempt_counter >= 0
      wait_1_minute
    end

  end

  def erase_logins
    self.update(logins: 0)
  end

  def wait_1_minute
    if

     # if the current time is less than 1 minute since the last bad attempt, update the counter again
      Time.now - session[:updated_at] <= 1.minute_ago


    else
      erase_logins
      login_attempt_counter


  end


end

  private

  def login_fail
    @user && @user.password != params[:user][:password]
  end
end


