defmodule Kraal.CmsTest do
  use Kraal.DataCase

  alias Kraal.Cms

  describe "posts" do
    alias Kraal.Cms.Post

    @valid_attrs %{content: "some content", title: "some title"}
    @update_attrs %{content: "some updated content", title: "some updated title"}
    @invalid_attrs %{content: nil, title: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Cms.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Cms.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Cms.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Cms.create_post(@valid_attrs)
      assert post.content == "some content"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cms.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, post} = Cms.update_post(post, @update_attrs)
      assert %Post{} = post
      assert post.content == "some updated content"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Cms.update_post(post, @invalid_attrs)
      assert post == Cms.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Cms.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Cms.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Cms.change_post(post)
    end
  end

  describe "posts" do
    alias Kraal.Cms.Post

    @valid_attrs %{content: "some content", published: true, published_at: "2010-04-17 14:00:00.000000Z", slug: "some slug", title: "some title"}
    @update_attrs %{content: "some updated content", published: false, published_at: "2011-05-18 15:01:01.000000Z", slug: "some updated slug", title: "some updated title"}
    @invalid_attrs %{content: nil, published: nil, published_at: nil, slug: nil, title: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Cms.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Cms.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Cms.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Cms.create_post(@valid_attrs)
      assert post.content == "some content"
      assert post.published == true
      assert post.published_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert post.slug == "some slug"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cms.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, post} = Cms.update_post(post, @update_attrs)
      assert %Post{} = post
      assert post.content == "some updated content"
      assert post.published == false
      assert post.published_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert post.slug == "some updated slug"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Cms.update_post(post, @invalid_attrs)
      assert post == Cms.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Cms.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Cms.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Cms.change_post(post)
    end
  end
end
