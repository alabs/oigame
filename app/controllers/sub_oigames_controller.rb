class SubOigamesController < ApplicationController
  # para cancan
  load_resource :find_by => :slug
  authorize_resource

  layout 'application', :except => [:widget, :widget_iframe]
  before_filter :authenticate_user!, :only => [:new, :edit, :create, :update, :destroy]
  skip_authorize_resource :only => [:widget, :widget_iframe]

  # GET /o
  # GET /o.json
  def index
    @sub_oigames = SubOigame.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sub_oigames }
    end end

  # GET /o/1
  # GET /o/1.json
  def show
    @sub_oigame = SubOigame.find_by_slug(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @sub_oigame }
    end
  end

  # GET /o/new
  # GET /o/new.json
  def new
    @sub_oigame = SubOigame.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sub_oigame }
    end
  end

  # GET /o/1/edit
  def edit
    @sub_oigame = SubOigame.find_by_slug(params[:id])
  end

  # POST /o
  # POST /o.json
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

  # PUT /o/1
  # PUT /o/1.json
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

  # DELETE /o/1
  # DELETE /o/1.json
  def destroy
    @sub_oigame = SubOigame.find_by_slug(params[:id])
    @sub_oigame.destroy

    respond_to do |format|
      format.html { redirect_to sub_oigames_url }
      format.json { head :ok }
    end
  end

  def widget
    @sub_oigame = SubOigame.find_by_slug(params[:sub_oigame_id])
  end

  def widget_iframe
    @sub_oigame = SubOigame.find_by_slug(params[:sub_oigame_id])
    render :partial => "widget_iframe"
  end

  def integrate
    @sub_oigame = SubOigame.find_by_slug(params[:sub_oigame_id])
  end

end
