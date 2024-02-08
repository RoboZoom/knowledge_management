defmodule KMWeb.BaseGPTLive do
  use KMWeb, :live_view
  use KM.HomeModels

  alias KMWeb.SubmitForm
  alias KMWeb.Message
  alias KMWeb.MessageContent
  alias KMWeb.Source

  import KMWeb.KMMessage
  import KMWeb.Filter

  def mount(_params, _session, socket) do
    sources = [
      %Source{id: 1, author: "Bart Simpson", title: "How to salute your shorts"},
      %Source{id: 2, author: "Homer Simpson", title: "How to eat a donut"}
    ]

    form = %Form{} |> Form.changeset(%{}) |> to_form()

    {:ok,
     socket
     |> assign(form: form)
     |> assign(messages: [])
     |> assign(page_title: "Chester Bot")
     |> assign(waiting: false)
     |> assign(sources: sources)}
  end

  def render(assigns) do
    ~H"""
    <div class="flex w-full flex-col items-stretch justify-items-center">
      <div class="min-h-150">
        <div class="flex items-start justify-items-stretch">
          <.simple_form for={@form} phx-submit="save" phx-validate="validate" class="w-2/3">
            <div class="my-4">
              <.button type="button" phx-click="add_filter">Add Filter</.button>
            </div>
            <div class="my-4">
              <fieldset class="flex flex-col gap-2">
                <legend>Filters</legend>
                <.inputs_for :let={f} field={@form[:filters]}>
                  <.filter item={f} />
                </.inputs_for>
              </fieldset>
            </div>
            <div class="border rounded-xl border-slate-700 h-80 p-5">
              <div :for={m <- @messages}>
                <.km_message message={m} />
              </div>
            </div>
            <div>
              <.input type="text" field={@form[:submission]} />
            </div>
            <div class="py-4">
              <.button>Submit</.button>
            </div>
          </.simple_form>
          <div class="px-6">
            <.heading2>Sources</.heading2>
            <.table id="sources" rows={@sources}>
              <:col :let={source} label="Author"><%= source.author %></:col>
              <:col :let={source} label="Title"><%= source.title %></:col>
              <:col :let={source} label="Published Date"><%= source.published_date %></:col>
            </.table>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("save", %{"form" => params}, socket) do
    changeset = Form.changeset(socket.assigns.base, params)

    case Ecto.Changeset.apply_action(changeset, :insert) do
      {:ok, data} ->

        

        socket =
          put_flash(socket, :info, "Submitted successfully")
          |> assign(waiting: true)
          |> reset_form()

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end

    m =
      socket.assigns.messages
      |> add_message_line(%Message{sender: 1, content: [%MessageContent{text: params["text"]}]})
      |> add_message_line(%Message{sender: 2, content: [%MessageContent{text: "Got it!"}]})

    {:noreply,
     socket
     |> assign(messages: m)
     |> reset_form()
     |> IO.inspect()}
  end

  def handle_event("highlight_change", %{id: id}, socket) do
    {:noreply, socket}
  end

  def handle_event("validate", %{"form" => form}, socket) do
    changeset =
      socket.assigns.base
      |> Form.changeset(form)
      |> struct!(action: :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("add_filter", _params, socket) do
    socket =
      update(socket, :form, fn %{source: changeset} ->
        existing = Ecto.Changeset.get_embed(changeset, :filters)
        changeset = Ecto.Changeset.put_embed(changeset, :filters, existing ++ [%{}])
        to_form(changeset)
      end)

    {:noreply, socket}
  end

  def handle_event("delete_filter", %{"index" => index}, socket) do
    index = String.to_integer(index)

    socket =
      update(socket, :form, fn %{source: changeset} ->
        existing = Ecto.Changeset.get_embed(changeset, :filters)
        {to_delete, rest} = List.pop_at(existing, index)

        filters =
          if Ecto.Changeset.change(to_delete).data.id do
            List.replace_at(existing, index, Ecto.Changeset.change(to_delete, delete: true))
          else
            rest
          end

        changeset
        |> Ecto.Changeset.put_embed(:filters, filters)
        |> to_form()
      end)

    {:noreply, socket}
  end

  defp add_message_line(nil, new) do
    [new]
  end

  defp add_message_line(old, new) do
    old ++ [new]
  end

  defp reset_form(socket) do
    # form = %SubmitForm{text: ""} |> convert_struct_to_form()
    form = %Form{} |> Form.changeset() |> to_form()
    socket |> assign(form: form)
  end

  defp clear_text(socket) do
    socket.assigns
  end

  defp convert_struct_to_form(s) do
    Map.from_struct(s)
    |> Enum.into([])
    |> Enum.map(&tuple_str(&1))
    |> Enum.into(%{})
    |> to_form(as: :submit_form)
  end

  defp tuple_str({a, b}) when is_atom(a) do
    {Atom.to_string(a), b}
  end
end
