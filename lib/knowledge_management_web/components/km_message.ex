defmodule KMWeb.KMMessage do
  use Phoenix.Component

  alias KMWeb.Message
  alias KMWeb.MessageContent

  attr :message, :any, required: true

  def km_message(assigns) do
    ~H"""
    <div class={set_dialogue_style(@message.sender)}>
      <span class="font-bold"><%= get_sender(@message.sender) %>:</span>
      <span :for={c <- @message.content}><%= c.text %></span>
    </div>
    """
  end

  def get_sender(1), do: "Me"
  def get_sender(2), do: "ChesterBot"

  def set_dialogue_style(1) do
    "italic text-brand my-2"
  end

  def set_dialogue_style(2) do
    "text-black my-2"
  end
end
