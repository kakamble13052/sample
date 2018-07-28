class WelcomeController < ApplicationController
  def index
    SendDeadlineExpiryMailJob.perform_now
  end
end
