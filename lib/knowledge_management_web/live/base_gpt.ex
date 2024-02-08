defmodule KMWeb.BaseGPTLive do
  use KMWeb, :live_view
  use KM.HomeModels

  alias KMWeb.Message
  alias KMWeb.MessageContent

  import KMWeb.KMMessage
  import KMWeb.Filter

  def mount(_params, _session, socket) do
    KMWeb.Endpoint.subscribe("chats")

    sources = []

    {:ok,
     socket
     |> reset_chat()
     |> assign(page_title: "Chester Bot")
     |> assign(sources: sources)
     |> assign(messages: [])}
  end

  def render(assigns) do
    ~H"""
    <div class="flex w-full flex-col items-stretch justify-items-center">
      <div class="min-h-150">
        <div class="flex items-start justify-items-stretch">
          <.simple_form for={@form} phx-submit="save" phx-validate="validate" class="w-1/2">
            <.input
              type="select"
              label="Choose your model/dataset"
              field={@form[:model]}
              options={[{"CCPGPT", :china}, {"Policy Analysis", :policy}]}
            />
            <div class="my-4 flex gap-8">
              <.button type="button" phx-click="add_filter">Add Filter</.button>
              <.button type="button" phx-click="demo">Demo Prompt</.button>
              <.button type="button" phx-click="demo-2">Demo Prompt Two</.button>
            </div>
            <div class="my-4">
              <fieldset class="flex flex-col gap-2">
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
            <div class="py-4 flex gap-8">
              <.button>Submit</.button>
              <.button type="button" phx-click="reset_chat">Reset Chat</.button>
              <.button type="button" phx-click="sources_only">Source Search</.button>
            </div>
          </.simple_form>
          <div class="px-6 w-1/2">
            <%!-- <.heading2>Sources</.heading2> --%>
            <.table id="sources" rows={@sources}>
              <:col :let={source} label="Title"><%= source.title %></:col>
              <:col :let={source} label="Region"><%= source.region %></:col>
              <:col :let={source} label="Source Type"><%= source.type %></:col>
            </.table>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("save", %{"form" => params}, socket) do
    changeset =
      Form.changeset(%Form{filters: []}, params)
      |> Ecto.Changeset.put_change(:id, socket.assigns.chat_id)

    case Ecto.Changeset.apply_action(changeset, :insert) do
      {:ok, data} ->
        socket =
          put_flash(socket, :info, "Submitted successfully")
          |> assign(waiting: true)
          |> reset_form()

        response = KM.Output.submit_request(data)

        source_ids =
          Enum.map(response, &Map.get(&1, "source", nil))
          |> MapSet.new()

        sources = KM.GetSources.get_sources(MapSet.to_list(source_ids))

        new_messages =
          socket.assigns.messages
          |> add_message_line(%Message{
            sender: 1,
            content: [%MessageContent{text: params["submission"]}]
          })
          |> add_message_line(%Message{
            sender: 2,
            content:
              Enum.map(
                response,
                &%MessageContent{
                  text: Map.fetch!(&1, "text"),
                  source_id: Map.fetch!(&1, "source")
                }
              )
          })

        {:noreply,
         socket
         |> assign(messages: new_messages)
         |> assign(sources: sources)}

      {:error, changeset} ->
        {:noreply, assign(socket, form: to_form(changeset) |> IO.inspect())}
    end
  end

  def handle_info("chat_received", params, socket) do
    new_messages =
      socket.assigns.messages
      |> add_message_line(%Message{
        sender: 2,
        content: [%MessageContent{text: params.text, source_id: params.source_id}]
      })

    IO.inspect("Message Received!")

    {:noreply, socket |> assign(messages: new_messages)}
  end

  def handle_event("sources_only", _params, socket) do
    socket =
      put_flash(socket, :info, "Submitted successfully")
      |> assign(waiting: true)
      |> reset_form()

    # response = KM.Output.submit_request(data)

    # source_ids =
    #   Enum.map(response, &Map.get(&1, "source", nil))
    #   |> MapSet.new()

    sources = KM.GetSources.get_source_list()

    {:noreply, socket |> assign(sources: sources)}

    # new_messages =
    #   socket.assigns.messages
    #   |> add_message_line(%Message{
    #     sender: 1,
    #     content: [%MessageContent{text: params["submission"]}]
    #   })
    #   |> add_message_line(%Message{
    #     sender: 2,
    #     content:
    #       Enum.map(
    #         response,
    #         &%MessageContent{
    #           text: Map.fetch!(&1, "text"),
    #           source_id: Map.fetch!(&1, "source")
    #         }
    #       )
    #   })
  end

  def handle_event("reset_chat", _params, socket) do
    {:noreply, socket |> reset_chat}
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

  def handle_event("demo", _params, socket) do
    c =
      Form.changeset(%Form{}, %{})
      |> Ecto.Changeset.put_change(:submission, "Methods of levying anti-dumping duties ")
      |> to_form()

    {:noreply,
     socket
     |> assign(form: c)}
  end

  def handle_event("demo-2", _params, socket) do
    c =
      Form.changeset(%Form{}, %{})
      |> Ecto.Changeset.put_change(
        :submission,
        "Give me a history of PLAN expansion across the South China Sea and beyond going back 25 years. Include a list of relevant sources. Give specific examples of vessel acquisition and development."
      )
      |> to_form()

    {:noreply,
     socket
     |> assign(form: c)}
  end

  defp reset_chat(socket) do
    new_id = Ecto.UUID.generate()

    # form = %Form{} |> Form.changeset(%{}) |> to_form()

    socket
    |> assign(chat_id: new_id)
    |> assign(messages: [])
    |> assign(sources: [])
    |> reset_form()
  end

  defp add_message_line(nil, new) do
    [new]
  end

  defp add_message_line(old, new) do
    old ++ [new]
  end

  defp reset_form(socket) do
    # form = %SubmitForm{text: ""} |> convert_struct_to_form()
    form = %Form{} |> Form.changeset(%{}) |> to_form()

    socket
    |> assign(form: form)
    |> assign(waiting: false)

    # |> assign(messages: [])
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
