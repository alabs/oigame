class TweetsController < ApplicationController

  respond_to :json

  def index
    @tweets = Tweet.last_messages('json', 10)
    respond_with(@tweets)
  end
end
