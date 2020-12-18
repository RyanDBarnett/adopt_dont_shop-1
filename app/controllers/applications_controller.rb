class ApplicationsController < ApplicationController
  def show
    @application = Application.find(params[:id])
    if request.env['PATH_INFO'].split('/')[1] == 'admin'
      render :show_admin
    else
      @matched_pets = Pet.filter_by_name(params['add-a-pet-search'])
    end
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

  def update
    @application = Application.find(params[:id])
    @application.update! application_params
    render :show
  end

  private

  def application_params
    params.permit(:name, :address, :city, :state, :zip, :status, :description)
  end
end
