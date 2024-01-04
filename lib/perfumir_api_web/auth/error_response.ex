defmodule PerfumirApiWeb.Auth.ErrorResponse.Unauthorized do
  defexception message: "Unauthorized", plug_status: 401
end

defmodule PerfumirApiWeb.Auth.ErrorResponse.Forbidden do
  defexception message: "Forbidden", plug_status: 403
end

defmodule PerfumirApiWeb.Auth.ErrorResponse.NotFound do
  defexception message: "NotFound", plug_status: 404
end
