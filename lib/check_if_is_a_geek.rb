module CheckIfIsAGeek

  def same_email?(email1, email2)
    user1 = email1.split('@').first
    user2 = email2.split('@').first.split('+').first
    
    domain1 = email1.split('@').last
    domain2 = email2.split('@').last

    if (user1 == user2) && (domain1 == domain2)
      return true
    else
      return false
    end
  end
end
