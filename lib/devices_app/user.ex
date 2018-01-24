defmodule DevicesApp.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias DevicesApp.User


  schema "users" do
    field :email, :string
    field :username, :string
    field :name, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :is_admin, :boolean, default: false

    has_many(:posts, DevicesApp.Post)

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :name, :username, :password_hash, :is_admin])
    |> validate_required([:email, :name, :username])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  @doc false
  def registration_changeset(struct, params) do
    struct
    |> changeset(params)
    |> cast(params, [:password], [])
    |> validate_length(:password, min: 6, max: 100)
    |> hash_password()
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true,
                      changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
