class ArtefactsController < ApplicationController
  before_filter :redirect_to_show_if_need_met, :only => :new
  before_filter :find_artefact, :only => [:show, :edit, :update]
  before_filter :build_artefact, :only => [:new, :create]
  before_filter :mark_removed_records_for_destruction, :only => :update

  respond_to :html, :json

  def index
    @artefacts = Artefact.order(:name).all
    respond_with @artefacts
  end

  def show
    respond_with @artefact do |format|
      format.html { redirect_to @artefact.admin_url }
    end
  end

  def new
  end

  def edit
  end

  def create
    @artefact.save
    location = @artefact.admin_url
    location += '?return_to=' + params[:return_to] if params[:return_to]
    respond_with @artefact, location: location
  end

  def update
    parameters_to_use = params[:artefact] || params.slice(*Artefact.attribute_names)

    save = @artefact.update_attributes(parameters_to_use)
    flash[:notice] = save ? 'Panopticon item updated' : 'Failed to save item'

    if save and params[:commit] == 'Save and continue editing'
      redirect_to edit_artefact_path(@artefact)
    else
      respond_with @artefact
    end
  end

  private
    def redirect_to_show_if_need_met
      if params[:artefact] and params[:artefact][:need_id]
        artefact = Artefact.find_by_need_id params[:artefact][:need_id]
        redirect_to artefact if artefact.present?
      end
    end

    def find_artefact
      @artefact = Artefact.from_param(params[:id])
    end

    def build_artefact
      @artefact = Artefact.new(params[:artefact] || params.slice(*Artefact.attribute_names))
    end

    # TODO: Convert this to a presenter

    def mark_removed_records_for_destruction
      [:related_artefacts].each do |association|
        reflection = Artefact.reflect_on_association association
        through_association, foreign_key = reflection.through_reflection.name, reflection.foreign_key

        mark_associated_records_for_destruction through_association,
          :if => -> attributes { attributes[foreign_key].blank? }
      end
    end

    def mark_associated_records_for_destruction(association, options)
      primary_key = Artefact.reflect_on_association(association).active_record_primary_key

      return unless params[:artefact] && params[:artefact][:"#{association}_attributes"]
      params[:artefact][:"#{association}_attributes"].each_value do |attributes|
        attributes[:_destroy] = attributes[primary_key].present? && options[:if].call(attributes)
      end
    end
end
