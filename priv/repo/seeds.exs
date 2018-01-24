# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DevicesApp.Repo.insert!(%DevicesApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
DevicesApp.Repo.insert!(%DevicesApp.User{
  email: "renato@mail.com",
  name: "Renato Ramiro",
  username: "renato", is_admin: true,
  password_hash: Comeonin.Bcrypt.hashpwsalt("12345678")
})
