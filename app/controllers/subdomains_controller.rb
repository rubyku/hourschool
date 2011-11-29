class SubdomainsController < ApplicationController
  # GET /subdomains
  # GET /subdomains.xml
  before_filter :authenticate_member!
  #, :except => [:index, :show]
  before_filter :match_member
  #, :except => [:index, :show]
  respond_to :html

  def index
    @subdomains = Subdomain.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @subdomains }
    end
  end

  # GET /subdomains/1
  # GET /subdomains/1.xml
  def show
    @subdomain = Subdomain.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @subdomain }
    end
  end

  # GET /subdomains/new
  # GET /subdomains/new.xml
  # def new
  #    @subdomain = Subdomain.new
  #
  #    respond_to do |format|
  #      format.html # new.html.erb
  #      format.xml  { render :xml => @subdomain }
  #    end
  #  end
  #
  #  # GET /subdomains/1/edit
  #  def edit
  #    @subdomain = Subdomain.find(params[:id])
  #  end
  #
  #  # POST /subdomains
  #  # POST /subdomains.xml
  #  def create
  #    @subdomain = Subdomain.new(params[:subdomain])
  #
  #    respond_to do |format|
  #      if @subdomain.save
  #        format.html { redirect_to(@subdomain, :notice => 'Subdomain was successfully created.') }
  #        format.xml  { render :xml => @subdomain, :status => :created, :location => @subdomain }
  #      else
  #        format.html { render :action => "new" }
  #        format.xml  { render :xml => @subdomain.errors, :status => :unprocessable_entity }
  #      end
  #    end
  # end
  #
  #  # PUT /subdomains/1
  #  # PUT /subdomains/1.xml
  #  def update
  #    @subdomain = Subdomain.find(params[:id])
  #
  #    respond_to do |format|
  #      if @subdomain.update_attributes(params[:subdomain])
  #        format.html { redirect_to(@subdomain, :notice => 'Subdomain was successfully updated.') }
  #        format.xml  { head :ok }
  #      else
  #        format.html { render :action => "edit" }
  #        format.xml  { render :xml => @subdomain.errors, :status => :unprocessable_entity }
  #      end
  #    end
  #  end
  #
  #  # DELETE /subdomains/1
  #  # DELETE /subdomains/1.xml
  #  def destroy
  #    @subdomain = Subdomain.find(params[:id])
  #    @subdomain.destroy
  #
  #    respond_to do |format|
  #      format.html { redirect_to(subdomains_url) }
  #      format.xml  { head :ok }
  #    end
  #  end
  protected

     def match_member
       @subdomain = Subdomain.find(params[:id])
       @enterprise = @subdomain.enterprise
       unless current_member.organization == @enterprise.name
         redirect_to current_member, :alert => "You can only access your organization's hourschool page"
       end

     end

end
