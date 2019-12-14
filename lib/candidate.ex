defmodule Candidate do
  defstruct [:id, :name, votes: 0]

  @doc """
  new method creates a new candidata

  ## Parameters
    - id: candidate id
    - name: name of the candidate

  ## Example
    iex> Candidate.new(1, "Joe Smith")
    %Candidate{id: 1, name: "Joe Smith", votes: 0}

  """

  def new(id, name) do
    %Candidate{id: id, name: name}
  end
end
