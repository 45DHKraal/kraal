defmodule Kraal.Cms.StatusEnum do
  use Exnumerator,
    values: [:publish, :pending, :draft, :auto_draft, :future, :private, :trash]
end
