defmodule Nova.ProductTest do
  use Nova.ModelCase
  alias Nova.Product
  alias Nova.Repo

  @valid_attrs %{
    description: "some content",
    name: "some content",
    price: 120.5,
    sku: "ABC"
  }

  test "changeset with valid attributes" do
    assert Product.changeset(%Product{}, @valid_attrs).valid?
  end

  test "changeset with invalid attributes" do
    refute Product.changeset(%Product{}, %{}).valid?
  end

  test "changeset with name length shorter than 3" do
    attrs = Map.merge(@valid_attrs, %{name: "a"})
    error = {:name, {"should be at least %{count} characters", [count: 3]}}

    assert error in errors_on(%Product{}, attrs)
  end

  test "changeset with name length longer than 200" do
    attrs = Map.merge(@valid_attrs, %{name: String.duplicate("a", 201)})
    error = {:name, {"should be at most %{count} characters", [count: 200]}}

    assert error in errors_on(%Product{}, attrs)
  end

  test "changeset with sku not unique" do
    product = Fixtures.product(sku: "ABC")
    product |> Repo.insert

    {:error, changeset} = product |> Repo.insert

    refute changeset.valid?
    assert {:sku, "has already been taken"} in changeset.errors
  end
end
