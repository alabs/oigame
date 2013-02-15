module Facebook
  class OpenGraph

    FB_URL = 'https://graph.facebook.com/me/oigameapp:sign'
    ACTIONS = {
        :fax => :send,
        :mailing => :send,
        :petition => :sign
    }

    def initialize(access_token,app_id)
      @graph = Koala::Facebook::API.new(access_token)
      @app = @graph.get_object(app_id)
      @access_token = access_token
    end

    def can_send_action? action
    end

    def send_action(class_name,fb_url)
      fb_post ACTIONS[class_name.to_sym] , fb_url
    end

    protected
    def fb_post(action, fb_url)
      data = {}
      data[:access_token] = @access_token
      data[:campaign] = fb_url
      data["fb:explicitly_shared"] = true
      response = HTTParty.post("#{FB_URL}",:body => data)
      Rails.logger.debug("FB RESPONSE: #{response.inspect}")
    end

  end

end
