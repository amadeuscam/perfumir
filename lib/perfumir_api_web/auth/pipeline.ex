defmodule PerfumirApiWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline, otp_app: :perfumir_api,
  module: PerfumirApiWeb.Auth.Guardian,
  error_handler: PerfumirApiWeb.Auth.GuardianErrorHandler

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource

end
