class AdminsController < ApplicationController
    
    
    
    
    
    
    def admin_params
        params.require(:admin).permit(
                :id,
                :email,
                :password,
                :first_name,
                :last_name
        )
    end
    
end
