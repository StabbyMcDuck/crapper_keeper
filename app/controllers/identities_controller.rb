class IdentitiesController < ApplicationController
  before_action :authenticate
  before_action :set_identity, only: [:show, :edit, :update, :destroy]

  # GET /identities
  # GET /identities.json
  def index
    @identities = policy_scope(Identity)
  end

  # GET /identities/1
  # GET /identities/1.json
  def show
  end

  # GET /identities/new
  def new
    @identity = Identity.new(user_id: current_user.id, uid: SecureRandom.uuid, oauth_token: SecureRandom.uuid, provider: 'crapper_keeper_http_basic')
    authorize @identity
    @identity.save!
    redirect_to @identity, notice: 'Identity was successfully created.'
  end

  # DELETE /identities/1
  # DELETE /identities/1.json
  def destroy
    @identity.destroy
    respond_to do |format|
      format.html { redirect_to identities_url, notice: 'Identity was successfully destroyed.' }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_identity
    @identity = Identity.find(params[:id])
    authorize @identity
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def identity_params
    params.require(:identity).permit(:name, :description, :parent_id, :user_id)
  end
end
