module ApplicationHelper

  def avatar_url(email)
    gravatar_id = Digest::MD5::hexdigest(email).downcase
    "https://secure.gravatar.com/avatar/#{gravatar_id}.png?s=48&d=mm"
  end

  def generate_from_for_validate(default_from, sub_oigame = nil)
    if sub_oigame.nil?
      return default_from
    else
      unless sub_oigame.from.empty?
        return sub_oigame.from
      else
        return default_from
      end
    end
  end

  def get_base64logo(campaign = nil)
    # devolvemos un logo en base64 para un suboigame o para el oiga.me general. 
    logo_oigame = "/9j/4AAQSkZJRgABAQEAWQBZAAD/2wBDAAUDBAQEAwUEBAQFBQUGBwwIBwcHBw8LCwkMEQ8SEhEPERETFhwXExQaFRERGCEYGh0dHx8fExciJCIeJBweHx7/2wBDAQUFBQcGBw4ICA4eFBEUHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh4eHh7/wAARCAA6AH0DASIAAhEBAxEB/8QAHQABAAMAAgMBAAAAAAAAAAAAAAYHCAMFAQIECf/EADkQAAEDAwQBAgQCCQIHAAAAAAECAwQFBhEABxIhCBMxFCJBUTJxFRZCUmFigaGzI5IJMzaRk7HS/8QAGwEBAAEFAQAAAAAAAAAAAAAAAAUCAwQGBwH/xAArEQABBAECBAQHAQAAAAAAAAABAAIDEQQhMQUSQVEGE3GBFCJhkbHR8TL/2gAMAwEAAhEDEQA/ANl6aaaImmqf8j9xtwbBetlFjWT+sqalKW1MJZdc4Y4cW0+mRwUvkrClZA4no/S30FSkJKk8VEZKc5wftoi86aaaImmmmiJpprilSY8VhT8p9phlAypx1QSkfmT1ovQCTQXLpqGP7qbfN1uJRUXVT5M+W+mOy3GUXgVqPEAqQClPf3I19N1bi2Pa4WK3c1OjOo6Uwl31Hv8Axoyr+2qPMZvayvgMrmDfKdZ20OvopVqJbm7h23t/SPja3KBkOA/DQmiC8+f5R9B91HofngGnL/8AJuKW1U+w6S/KluHgiZMbwkE9Dg0DyWftnHf0OoBK2Y3cu+T+nrhfiN1GaOSUVOdxkLH0ASAQnA/Z6x7YGsWXLvSIWVsnD/DIYWy8UeImHYE04/od+v5XQ3lvNeFx3rAuJUkw2abJS/BgMrPpN4P7X75IyCo+4JAABxrcVEqEer0aFVYiuUeZHbkNH7pWkKH9jr87LvtmuWlXHaLcFPchTWwFcVEFK0n2UlQ6Uk4PY+xHuDrZfivWjWNmaWhxzm7T3HISyT7cVZSP6IUgasYMrjI5r9yprxlw7GZgwz4oAa01ptR1HrqN/qqMrF47peQW7tatHbq5nLVtShqUh6bHcUhboCigOKUjC1FZCilAKUhI77GTxO3Rur427j0Gm35d7t3WZWlFKpEha3FtJSoBakleVoWjmlRTkpUk49+09Z4c3NRNpdz78sa+6ixRJL7zbbUmcsNNKWwp0EFauhyS4FJJwCB79jPJ5t3dRNzrpsuwrBqES4KgmS56jkJwPNBx700toDicg+yirH4QBn64lVzZTPzwvO7LVqNit2vclTo6ZrkoSBDkKbDoSWOPLHvjkcfmdTHy53lqO19s02mWy227c1bUpEVS0BwR204CnOH7SiVJSkHonJOcYNVf8QpkR6rtjECioN/FIBPucKjDOuTz+iTKLuDt9fZjLkU+Iv0nMD5Q406l0IJ9gVJKsffgr7aIuW4LH8oLRsSo3w/uoqXLjQnJU2lF9TnptcCXOBUnhzQMn5cY4/KScZn/AIL3Vc94bU1ioXLXZtVmt1hxll+WsuKQgMtED8sknH8dSLdzdrbiTsbcdQiXnRZCajRJLUNlqWhTzrjrKkoQGweYVlQBBA498sYOss2NVq7RvBW636G48z8Tc6Y015olKm4622QrsewUeCD9wsj66IprXW95JdemB3yYsyPWEvuIj0xisIYSviohCOCU8EqVgfKcnsAnOdWh4gbz1rcKg12lXsWEVq3ShUiZxS0HmlcwVLSMJSpBQQojAwR10dVvsltx4zVXZin1W5atS3aq5F5VORMrJjPRXj+JAb5pACT0nKTyAB7zqE+JNIkVW3d36Xbi333HKW0iJxH+o8gOOkJx12tIxj+bVLjTSQr2PG2WVrHGgSBfazur83o8gKALem0Sx6lLfqz/ABaTPZa4NMp5fOUqVglWAQCkY7yD0NdvvWxtNYLNJqtbs5ia+px5MKBGaSltxR4lbjiThJ49DJz2s9H3GT7ituu2vXW6TcNMfp0zCHA07j5kKPSgQSCOiMg+4I9xrQPnSf8Ao4fxmn/BqKE73se5w1FfldKdwXFxsvDxsZ55JOckg6upo6jp6dz3Ussyk7PbwW0au1Z8almnSAmS022mMpOAFYUpogLQR/6PsdRW39wNjq9c0a1G9tozEObITFjzVwmhyUo8UE4+dIJI7zkZ7x3jz4g9baXur+c/4DqgdtRncK2R96tE/wAyNUumIax1CzvoqsbhbJJ8uJ0j+WKuX5jpYJWkbM2molreSwRESpymM0lVVgMOnmWXC4GuOT2rjkqST2Mp7JGdQW59md2bouKXctxTKPBlPulzlKqX/JGcpQkpBACR0MfbVu7gXGq1/Ie3J0iNJXTZlFcgyn2mlLSzyeKkqOB7BSU5+wJP01TG6Gwd8R7tmyLcpxrdJkvKdjOIkI5tJUchCwtQORnGRkEYPXsK5o2gENaTR2H8WPwvOnfKyWedrC6NtOcLuibAPMADsTdk6Fd/5HNw39obY/TFx0WrXdSnkxpC4kxLq3W1JUFEj8R/A2SSPfP312fhXX2otDuSlyneLbUlh9sfxWlSVf406pa+drrssigQ6xckaJDTLkeg3HTJSt4HiVciE5HHojonv3xka+Gxbmft34z0FlPxHDOD+7y/+tWBMWTB7hX8U07hMWVwh+NBIHgusEVQ+ayBWlbrZ252zO3G40tE66bdafnoQEJmMOrYe4j2ClII5AfQKzj6a9NstlNttuZxqNsW621USko+NkOrfeSk9EJKyeGR0eIGR76sTTU4uNqC7o7T2XuVLpUq64MmS7SisxC1JW1x5lJVnie/wJ99SO8LZoN30CRQblpcep02QB6jDwOMj2IIwUqH0UCCPoddvpoiw15JWNsFtJT6hTKfTalPvCdCP6PhPyHVsxEu8kCQVdA8cKKQSo8gMjHYvfxT20/V3x6Yt27aWhxdcW7MnwJTYISl0BKW1pP19NCCQewSR7jVlVSxLPql5xLxqdvwptdhsJYjTH0lamUJWpaeKSeKVBS1EKA5d++pJoioVnxJ2abrYqP6Mqq2AvkIC6gsx/y/fI/NeprtHs3Zu11Sq061UT0LqoQH0PvhaEhKlFIQAkYHzH7/AE1YumiKl94dk6juFejFecu1qIww0hlmMafz9JKSVHBDg5EqJPeNQzd+xd49y6/HhVCjURiFSHn0RJ7T3pIkJc4fMUFa1jpCesdZIydab01jvxWOv67qexPEeXjcmjXeWCG2P83vVVuO9rE23l313bWv1jbhwUdtqdUjCnTpCXFJY79IuJwU5Tj5u8f01prZ3a6lbdUV2E0+iqSnX/WVMdioQ4PlSOIIyQn5c4yeydZZ8pqSulb0VdfApanJaltnHuFIAUf9yV/9taT8Y7zdu/bKOma76lRpS/gpCie1pSAW1n80kAn6lKjrExSBKY3dNltHiZkknDo82A02TlLwOprQ+2o+ytLTTTUmucqL3jt5Zd3KLlwW7CmPlPH4gJLb2Pp/qJIV/fVXjxjtJE+S6zWakIrnEtMrCVKaPefm6yDkY6yMe5zq+NNWnwRvNuCk8XjOfiM5IZSB2vT2vb2TTTTV1RiaaaaImmmmiJpppoiaaaaIs6ealouzKNTLyiNFZgExJpA7DSzltR/gFkj83BqH+FVd+Cv2qUJxzi3UoXqIST+J1pWQP9qnD/TWrbgjsS6DPjSmGn2HYziXG3EBSVgpOQQeiNUF4SQYRoVeqBiRzMTKS0mR6Y9QIKclIV74yAce2o6SPlymuHVb7w/PM3hyeCQWGaD3Nj7H9LRemmmpFaEmmmmiL//Z"
    # comprobamos si es una campania, si tiene sub y si ese sub tiene logo
    if campaign and campaign.sub_oigame and campaign.sub_oigame.logobase64 then
      return campaign.sub_oigame.logobase64
    else
    # si no pertenece, le devolvemos el de oiga.me
      return logo_oigame
    end
  end

  def show_meta_tags
    data = ""
    data << "<meta property='og:description' content='#{@meta['description']}' />\n"
    data << "<meta name='description' content='#{@meta['description']}' />\n"
    data << "<meta property='og:title' content='#{@meta['title']}' />\n"
    ['fb','og','oigameapp'].each do |tec|
      @meta[tec].each do |key,content|
        data << "<meta property='#{tec}:#{key}' content='#{content}' />\n"
      end
    end
    data.html_safe
  end
end
