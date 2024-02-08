defmodule KMWeb.Filter do
  use Phoenix.Component

  import KMWeb.CoreComponents

  attr :item, :any, required: true

  def filter(assigns) do
    ~H"""
    <div class="flex gap-10">
      <.input type="select" field={@item[:field]} options={[{"Author", :author}, {"Title", :title}]} />
      <.input
        type="select"
        field={@item[:comparator]}
        options={[{"Equals", :eq}, {"Greater Than", :gt}, {"Less Than", :lt}]}
      />
      <.input type="text" field={@item[:parameter]} />
      <.button type="button" phx-click="delete_filter" phx-value-index={@item.index} }>
        Delete
      </.button>
    </div>
    """
  end
end
