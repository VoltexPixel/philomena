defimpl Canada.Can, for: [Atom, Philomena.Users.User] do
  alias Philomena.Users.User
  alias Philomena.Images.Image
  alias Philomena.Forums.Forum
  alias Philomena.Topics.Topic

  # Admins can do anything
  def can?(%User{role: "admin"}, _action, _model), do: true

  #
  # Moderators can...
  #

  # View images
  def can?(%User{role: "moderator"}, :show, %Image{}), do: true

  # View forums
  def can?(%User{role: "moderator"}, :show, %Forum{access_level: level})
    when level in ["normal", "assistant", "staff"], do: true
  def can?(%User{role: "moderator"}, :show, %Topic{hidden_from_users: true}), do: true

  #
  # Assistants can...
  #

  # View images
  def can?(%User{role: "assistant"}, :show, %Image{}), do: true

  # View forums
  def can?(%User{role: "assistant"}, :show, %Forum{access_level: level})
    when level in ["normal", "assistant"], do: true
  def can?(%User{role: "assistant"}, :show, %Topic{hidden_from_users: true}), do: true

  #
  # Users and anonymous users can...
  #

  # View non-deleted images
  def can?(_user, action, Image)
      when action in [:new, :create, :index],
      do: true

  def can?(_user, :show, %Image{hidden_from_users: false}), do: true

  # View forums
  def can?(_user, :show, %Forum{access_level: "normal"}), do: true
  def can?(_user, :show, %Topic{hidden_from_users: false}), do: true

  # Otherwise...
  def can?(_user, _action, _model), do: false
end