class API::V1::ContainersController < API::V1::APIController
  before_action :authenticate
  before_action :authorize_parent, only: [:create, :update]
  before_action :set_container, only: [:show, :edit, :update, :destroy]

  # GET /containers
  # GET /containers.json
  def index
    @containers = policy_scope(Container)
  end

  # GET /containers/1
  # GET /containers/1.json
  def show
  end

  # GET /containers/new
  def new
    @container = Container.new
  end

  # GET /containers/1/edit
  def edit
  end

  # POST /containers
  # POST /containers.json
  def create
    @container = Container.new(container_params)
    @container.user = current_user
    authorize @container

    respond_to do |format|
      if @container.save
        format.json { render :show, status: :created, container: @container }
      else
        format.json { render json: @container.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /containers/1
  # PATCH/PUT /containers/1.json
  def update
    respond_to do |format|
      if @container.update(container_params)
        format.json { render :show, status: :ok, location: @container }
      else
        format.json { render json: @container.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /containers/1
  # DELETE /containers/1.json
  def destroy
    @container.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  def authorize_parent
    parent_id = container_params['parent_id']

    if parent_id
      parent = Container.find(parent_id)
      authorize parent, :show?
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_container
    @container = Container.find(params[:id])
    authorize @container
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def container_params
    params.require(:container).permit(:name, :description, :image, :parent_id)
  end
end
