module Facebook
  class OpenGraph

    FB_URL = 'https://graph.facebook.com/me/oigameapp:'
    ACTIONS = {
        :fax => :send,
        :message => :send,
        :petition => :sign
    }

    def initialize(access_token,app_id)
      @graph = Koala::Facebook::API.new(access_token)
      @app = @graph.get_object(app_id)
      @access_token = access_token
    end

    def can_send_action? action
    end

    def send_action(obj)
      model_name = obj.model.name
      fb_url = send "#{model_name}_url", obj
      fb_post ACTIONS[model_name.to_sym] , fb_url
    end

    protect
    def fb_post action, fb_url
      data = {}
      data[:access_token] = @acces_token
      data[:campaign] = fb_url
      data["fb:explicitly_shared"] = true
      HTTParty.post("#{FB_URL}#{action}")
    end

  end

end
