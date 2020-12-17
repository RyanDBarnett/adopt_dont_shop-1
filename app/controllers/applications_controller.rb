class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    @matched_pets = Pet.all.where('name = ?', params['add-a-pet-search'])
  end

  def new

  end

  def create
    application = Application.new(application_params)
    if application.save
      redirect_to "/applications/#{application.id}"
    else
      flash[:notice] = "Application Not Created: You must fill out all fields."
      redirect_to '/applications/new'
    end
  end

  private

  def application_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
