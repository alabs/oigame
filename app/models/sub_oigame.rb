class SubOigame < ActiveRecord::Base
  #belongs_to :user
  has_many :campaigns

  before_save :generate_slug

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug = self.title.parameterize
  end

end
