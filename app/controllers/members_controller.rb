class MembersController < ApplicationController
  before_action :set_member, only: %i[ show edit update destroy ]

  # GET /members or /members.json
  def index
    @members = Member.all
  end

  # GET /members/1 or /members/1.json
  def show
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
  end

  # POST /members or /members.json
  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        format.html { redirect_to @member, notice: "Member was successfully created." }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1 or /members/1.json
  def update
    respond_to do |format|
      begin
        if @member.update(member_params)
          format.html { redirect_to @member, notice: "Member was successfully updated." }
          format.json { render :show, status: :ok, location: @member }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @member.errors, status: :unprocessable_entity }
        end
      rescue ActiveRecord::StaleObjectError
        flash[:alert] = "他のユーザーが変更しました。再度編集してください。"
        format.turbo_stream { render turbo_stream: turbo_stream.replace("flash", partial: "shared/flash") }
        format.html { redirect_to @member }
      end
    end
  end


  # DELETE /members/1 or /members/1.json
  def destroy
    @member.destroy!

    respond_to do |format|
      format.html { redirect_to members_path, status: :see_other, notice: "Member was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_member
      @member = Member.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def member_params
      params.require(:member).permit(:name, :email, :lock_version)
    end
end
