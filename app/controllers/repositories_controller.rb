class RepositoriesController < ApplicationController
  def create
    @repository = Repository.new
    if @repository.save
      render @repository
    else
      logger.error "Failed to create repository #{@repository.id}"
    end
  end
end
