class SubOigame < ActiveRecord::Base

  acts_as_paranoid

  has_and_belongs_to_many :users
  has_many :campaigns

  attr_accessible :name, :slug, :html_header, :html_footer, :html_style, :logo, :from, :user_ids

  before_save :generate_slug

  validates :name, :presence => true

  mount_uploader :logo, LogoUploader

  before_save :generate_base64_logo

  def to_param
    slug
  end

  def generate_slug
    self.slug = self.name.parameterize
  end

  def generate_base64_logo(file = self.logo.current_path)
    if file then
      fh = File.open(file)
      # generate base64
      require 'base64'
      base64 = Base64.encode64(fh.read)
      fh.close
      self.logobase64 = base64
    end
  end
end

