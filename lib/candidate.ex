defmodule Candidate do
  defstruct [:name, :id, votes: 0]

  def new(id, name) do
    %Candidate{id: id, name: name}
  end
end