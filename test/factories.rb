include ActionDispatch::TestProcess

FactoryGirl.define do

  factory :campaign do
    #validates :name, :image, :intro, :body, :ttype, :duedate_at, :presence => true
    name        "Salvemos a los tests"
    image       { fixture_file_upload("test/fixtures/files/campaign.gif", "image/gif") }
    intro       "Historicamente los tests de oiga.me fueron una mierda. Vamos a intentar de hacerlo bien"
    body        "Ipso lorem sit amet domini monthy python"
    ttype 	"petition"
    duedate_at  30.days.from_now
  end

  factory :user do 
    name                  "User Normal"
    email                 "normal@example.com"
    password              "normal"
    password_confirmation "normal"
  end

end
