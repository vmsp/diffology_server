class Repository
  include ActiveModel::Model

  attr_accessor :id

  def initialize(attributes={})
    super
    @id ||= SecureRandom.uuid
  end

  def save
    %x(git init --bare /var/www/repos/#{@id}.git)
  end
end
