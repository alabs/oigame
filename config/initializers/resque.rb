require 'resque'
require 'resque/server'

class CanAccessResque
  def self.matches?(request)
    current_user = request.env['warden'].user
    if current_user
      current_user.roles.include? "admin"
    else
      return false
    end
  end
end
