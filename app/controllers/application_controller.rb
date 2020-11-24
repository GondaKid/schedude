class ApplicationController < ActionController::Base
    def not_found
        render plain: 'Oh! Trang này không có tồn tại!'
    end
end