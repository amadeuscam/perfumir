defmodule PerfumirApiWeb.Auth.Guardian do
  use Guardian, otp_app: :perfumir_api
  alias PerfumirApi.Accounts
  alias PerfumirApiWeb.Auth.ErrorResponse

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_account!(id) do
      nil -> {:error, :not_found}
      resource -> {:ok, resource}
    end
  end

  def resource_from_claims(_claims) do
    {:error, :no_id_provider}
  end

  def auhenticate(email, password) do
    case Accounts.get_account_by_email(email) do
      nil ->
        {:error, :unauthorized}

      account ->
        case validate_password(password, account.hash_password) do
          true -> create_token(account, :access)
          false -> {:error, :unauthorized}
        end
    end
  end

  def auhenticate(token) do
    with {:ok, claims} <- decode_and_verify(token),
         {:ok, account} <- resource_from_claims(claims),
         {:ok, _old, {new_token, _claims}} <- refresh(token) do
      {:ok, account, new_token}
    else
      {:error, _message} -> raise ErrorResponse.NotFound
    end
  end

  def validate_password(password, hash_password) do
    Bcrypt.verify_pass(password, hash_password)
  end

  defp create_token(account, type) do
    {:ok, token, _claims} = encode_and_sign(account, %{}, token_options(type))
    {:ok, account, token}
  end

  defp token_options(type) do
    case type do
      :access -> [token_type: "access", ttl: {2, :hour}]
      :reset -> [token_type: "reset", ttl: {15, :minute}]
      :admin -> [token_type: "admin", ttl: {90, :day}]
    end
  end
end
