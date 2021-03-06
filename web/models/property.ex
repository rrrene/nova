defmodule Nova.Property do
  use Nova.Web, :model

  schema "nova_properties" do
    has_many :product_properties,
      Nova.ProductProperty,
      on_delete: :delete_all
    has_many :products, through: [:product_properties, :products]

    field :name, :string
    field :display_name, :string
  end

  @required_fields ~w(name display_name)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, ~w())
    |> validate_length(:name, min: 3, max: 200)
    |> validate_length(:display_name, min: 3, max: 200)
  end
end
