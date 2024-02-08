defmodule KMWeb.KMMessage do
  use Phoenix.Component

  attr :message, :any, required: true

  def km_message(assigns) do
    ~H"""
    <div class={set_dialogue_style(@message.sender)}>
      <span class="font-bold"><%= get_sender(@message.sender) %>:</span>
      <span :for={c <- @message.content} class={underline_style(c.source_id)}><%= c.text %></span>
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

  def underline_style(source_id) do
    case source_id do
      nil -> ""
      _ -> "underline decoration-dotted hover:decoration-dashed hover:decoration-brand "
    end
  end
end
