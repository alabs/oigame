class FaxPdf

  def initialize(fax, campaign)
    @fax = fax
    @campaign = campaign
  end

  def generate_pdf
    pdf = Prawn::Document.new
    pdf.move_down 10 
    pdf.font_size 10
    pdf.text @fax.name
    pdf.text @fax.email
    pdf.move_down 25
    pdf.font_size 16
    pdf.text @campaign.name
    pdf.move_down 15
    pdf.font_size 10
    pdf.text @campaign.intro 
    pdf.move_down 10
    pdf.text @campaign.body

    pdf.render
  end

  def logo_path
    logopath = "#{Rails.root}/app/assets/images/logo-small.png"
  end
end
