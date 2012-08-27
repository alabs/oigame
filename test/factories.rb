include ActionDispatch::TestProcess

FactoryGirl.define do

  factory :campaign do
    name        "Salvemos a los tests"
    intro       "Historicamente los tests de oiga.me fueron una mierda. Vamos a intentar de hacerlo bien"
    body        "Ipso lorem sit amet domini monthy python"
  #  duedate_at  30.days.from_now
  #  ttype 	"petition"
  #  image       { fixture_file_upload("test/fixtures/files/campaign.gif", "image/gif") }
  end

end
