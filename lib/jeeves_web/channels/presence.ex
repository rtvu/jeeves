defmodule JeevesWeb.Presence do
  use Phoenix.Presence, otp_app: :jeeves,
                        pubsub_server: Jeeves.PubSub
end
