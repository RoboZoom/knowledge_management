defmodule KM.HomeModels.Form do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "form" do
    field :submission, Ecto.Enum, values: [:gt, :lt, :eq, :not]

    embeds_many :filters, Filter do
      field :comparator, Ecto.Enum, values: [:gt, :lt, :eq, :not]
      field :field, :string
      field :parameter, :string
      field :model, :string
      field :delete, :boolean, virtual: true
    end
  end

  def changeset(filter, attr) do
    filter
    |> cast(attr, [:submission])
    |> cast_embed(:filters, with: &filter_changeset/2)

    # |> validate_required([ ])
  end

  def filter_changeset(obj, attrs) do
    c =
      obj
      |> cast(attrs, [:comparator, :field, :parameter, :model, :delete])
      |> validate_required([:comparator, :field, :model])

    if get_change(c, :delete) do
      %{c | action: :delete}
    else
      c
    end
  end
end
