defmodule KM.HomeModels.Form do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "form" do
    field :submission, :string
    field :model, :string

    embeds_many :filters, Filter do
      field :comparator, Ecto.Enum, values: [:gt, :lt, :eq, :not]
      field :field, :string
      field :parameter, :string
      field :delete, :boolean, virtual: true
    end
  end

  def changeset(form, attr) do
    form
    |> cast(attr, [:submission, :model])
    |> cast_embed(:filters, with: &filter_changeset/2)
    |> validate_required([:submission, :model])

    # |> validate_required([ ])
  end

  def filter_changeset(obj, attrs) do
    c =
      obj
      |> cast(attrs, [:comparator, :field, :parameter, :delete])
      |> validate_required([:comparator, :field])

    if get_change(c, :delete) do
      %{c | action: :delete}
    else
      c
    end
  end
end
