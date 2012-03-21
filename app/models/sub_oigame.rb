class SubOigame < ActiveRecord::Base
  belongs_to :user
  has_many :campaigns

  before_save :generate_slug

  validates :name, :user, :presence => true

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug = self.name.parameterize
  end

end

