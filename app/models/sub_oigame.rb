class SubOigame < ActiveRecord::Base
  belongs_to :user
  has_many :campaigns

  before_save :generate_slug

  validates_presence_of :name

  def to_param
    slug
  end

  private

  def generate_slug
    self.slug = self.name.parameterize
  end

end

