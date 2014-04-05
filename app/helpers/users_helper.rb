module UsersHelper
  
  def site_trusted?
    @self = true ? site_trusted == "Yes" : false
  end

  def site_trusted
    @self = request.headers["HTTP_EVE_TRUSTED"]
  end
end