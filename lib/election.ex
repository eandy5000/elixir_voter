defmodule Election do
  defstruct(
    name: "Mayor",
    candidates: [
      Candidate.new(1, "Bill Bailey"),
      Candidate.new(2, "Joe Smith")
    ],
    next_id: 3
  )

  def run() do
    %Election{} |> run()
  end

  def run(:quit), do: :quit

  def run(election = %Election{}) do
    [
      hack_clear(),
      hack_clear(),
      hack_clear()
    ]
    |> IO.write()

    election
    |> view()
    |> IO.write()

    command = IO.gets(">")

    election
    |> update(command)
    |> run()
  end

  def update(election, cmd) when is_binary(cmd) do
    update(election, String.split(cmd))
  end

  def update(_election, ["q" <> _]), do: :quit

  def update(election, ["n" <> _ | args]) do
    name = Enum.join(args, " ")
    # %{election | name: name}
    election
    |> Map.put(:name, name)
  end

  def update(election, ["a" <> _ | args]) do
    name = Enum.join(args, " ")

    candidate = Candidate.new(election.next_id, name)
    candidates = [candidate | election.candidates]
    # %{election | candidates: candidates, next_id: election.next_id + 1}
    election
    |> Map.put(:candidates, candidates)
    |> Map.put(:next_id, election.next_id)
  end

  def update(election, ["v" <> _, id]) do
    vote(election, Integer.parse(id))
  end

  defp vote(election, {id, ""}) do
    candidates = Enum.map(election.candidates, &maybe_inc_vote(&1, id))
    # %{election | candidates: candidates}
    election
    |> Map.put(:candidates, candidates)
  end

  defp vote(election, _errors), do: election

  def view(election = %Election{}) do
    [
      view_header(election),
      view_body(election),
      view_footer()
    ]
  end

  def view_header(election) do
    [
      "Election for: #{election.name}\n"
    ]
  end

  def view_body(election) do
    candidates =
      election.candidates
      |> sort_candidates_by_votes_desc()
      |> candidates_to_string()
      |> prepend_candidates_header()

    candidates
  end

  def view_footer() do
    [
      "\n",
      "commands: (n)ame <election>, (a)dd <candidate>, (v)ote <id>, (q)uit\n"
    ]
  end

  defp maybe_inc_vote(candidate, id) when is_integer(id) do
    maybe_inc_vote(candidate, candidate.id == id)
  end

  defp maybe_inc_vote(candidate, _inc_vote = false), do: candidate

  defp maybe_inc_vote(candidate, _inc_vote = true) do
    Map.update!(candidate, :votes, &(&1 + 1))
  end

  def prepend_candidates_header(candidates) do
    [
      "ID\tVotes\tName\n",
      "-----------------------------\n"
      | candidates
    ]
  end

  def candidates_to_string(candidates) do
    candidates
    |> Enum.map(fn %{id: id, name: name, votes: votes} ->
      "#{id}\t#{votes}\t#{name}\n"
    end)
  end

  def sort_candidates_by_votes_desc(candidates) do
    candidates
    |> Enum.sort(&(&1.votes >= &2.votes))
  end

  def hack_clear() do
    "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
  end
end
