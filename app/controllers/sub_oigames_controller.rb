class SubOigamesController < ApplicationController
  # para cancan
  load_resource :find_by => :slug

  # GET /sub_oigames
  # GET /sub_oigames.json
  def index
    @sub_oigames = SubOigame.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sub_oigames }
    end
  end

  # GET /sub_oigames/1
  # GET /sub_oigames/1.json
  def show
    @sub_oigame = SubOigame.find_by_slug(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sub_oigame }
    end
  end

  # GET /sub_oigames/new
  # GET /sub_oigames/new.json
  def new
    @sub_oigame = SubOigame.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sub_oigame }
    end
  end

  # GET /sub_oigames/1/edit
  def edit
    @sub_oigame = SubOigame.find_by_slug(params[:id])
  end

  # POST /sub_oigames
  # POST /sub_oigames.json
  def create
    @sub_oigame = SubOigame.new(params[:sub_oigame])

    respond_to do |format|
      if @sub_oigame.save
        format.html { redirect_to @sub_oigame, notice: 'Sub oigame was successfully created.' }
        format.json { render json: @sub_oigame, status: :created, location: @sub_oigame }
      else
        format.html { render action: "new" }
        format.json { render json: @sub_oigame.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sub_oigames/1
  # PUT /sub_oigames/1.json
  def update
    @sub_oigame = SubOigame.find_by_slug(params[:id])

    respond_to do |format|
      if @sub_oigame.update_attributes(params[:sub_oigame])
        format.html { redirect_to @sub_oigame, notice: 'Sub oigame was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @sub_oigame.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sub_oigames/1
  # DELETE /sub_oigames/1.json
  def destroy
    @sub_oigame = SubOigame.find_by_slug(params[:id])
    @sub_oigame.destroy

    respond_to do |format|
      format.html { redirect_to sub_oigames_url }
      format.json { head :ok }
    end
  end
end
