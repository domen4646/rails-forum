class UsersController < ApplicationController

    before_action :set_user, only: [:show, :set_role]
    before_action :can_change_role, only: [:set_role]

    def show
        #@user = User.find(params[:id])
    end

    def set_role
        #@user = User.find(params[:id])

        respond_to do |format|
            if @user.update(role_params)
                format.html { redirect_to user_url(@user), notice: "Uporabnik je bil uspešno posodobljen." }
                format.json { render :show, status: :ok, location: @user }
            else
                format.html { render :show, status: :unprocessable_entity }
                format.json { render json: @user.errors, status: :unprocessable_entity }
            end
        end
    end

    private
        def role_params
            params.permit(:role)
        end

        def require_admin
            user_signed_in? && current_user.admin?
        end

        def set_user
            @user = User.find(params[:id])
        end

        def can_change_role
            newparams = role_params
            rol = newparams["role"].to_i
            if !current_user.has_authority?
                redirect_to user_url(@user), notice: "Za spreminjanje ostalih uporabnikov so potrebne posebne pravice."
            elsif rol < 0 || rol > 2
                # handle invalid role error
                redirect_to user_url(@user), notice: "Neveljavna sprememba."
            elsif @user == current_user
                # handle modify yourself error
                redirect_to user_url(@user), notice: "Sprememba lastnega statusa ni dovoljena."
            elsif ((rol == 2 || @user.mod?) && !current_user.admin?) || @user.admin?
                # handle insufficient privileges
                redirect_to user_url(@user), notice: "Nimate dovolj pravic za spreminjanje tega uporabnika."
            end
        end

end
