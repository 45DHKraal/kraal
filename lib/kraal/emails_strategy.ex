defmodule Kraal.EmailsStrategy do
  @behaviour Bamboo.DeliverLaterStrategy
  require Logger

  # This is a strategy for delivering later using Task.async
  def deliver_later(adapter, email, config) do
    Task.async fn ->
      Logger.info "Sending email to #{email.to} with subject {email.subject}"
      # Always call deliver on the adapter so that the email is delivered.
      email = adapter.deliver(email, config)
      Logger.info fn ->{
        "Email sent",
        [email: email]
        } end
      email
    end
  end
end
