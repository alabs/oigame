class FaxPdf

  def initialize(fax)
    @fax = fax
  end

  def generate_pdf
    Prawn::Document.generate('/tmp/fax.pdf') do |pdf|
      pdf.image logo_path, :with => 125, :height => 58
      pdf.move_down 15
      pdf.font_size 10
      pdf.text "Remitente: #{@fax.name}"
      pdf.text "Email: #{@fax.email}"
      pdf.move_down 25
      pdf.font_size 16
      pdf.text @fax.campaign.name
      pdf.move_down 15
      pdf.font_size 10
      pdf.text @fax.body 
    end
  end

  def logo_path
    logopath = "#{Rails.root}/app/assets/images/logo-small.png"
  end
end
