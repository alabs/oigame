class FaxPdf

  def initialize(fax, campaign)
    @fax = fax
    @campaign = campaign
  end

  def generate_pdf
    pdf = Prawn::Document.new
    pdf.image logo_path, :with => 125, :height => 58
    pdf.move_down 15
    pdf.font_size 10
    pdf.text "Remitente: #{@fax.name}"
    pdf.text "Email: #{@fax.email}"
    pdf.move_down 25
    pdf.font_size 16
    pdf.text @campaign.name
    pdf.move_down 15
    pdf.font_size 10
    pdf.text @fax.body 
    pdf.move_down 30

    pdf.render
  end

  def logo_path
    logopath = "#{Rails.root}/app/assets/images/logo-small.png"
  end
end
