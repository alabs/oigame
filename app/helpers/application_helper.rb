module ApplicationHelper

  def get_base64logo(campaign)
    sub_oigame = campaign.sub_oigame
    if sub_oigame
      return sub_oigame.logobase64
    end
  end
end
