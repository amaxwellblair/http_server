module ResponseCodes

  def ok
    "200 OK"
  end

  def moved_permanently
    "301 Moved Permanently"
  end

  def unauthorized
    "401 Unauthorized"
  end

  def forbidden
    "403 Forbidden"
  end

  def not_found
    "404 Not Found"
  end

  def internal_server_error
    "500 Internal Server Error"
  end

end
