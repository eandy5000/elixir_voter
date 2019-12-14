defmodule Election do
  defstruct(
    name: "Dog Catcher",
    candidates: [
      Candidate.new(1, "Joe Smith"),
      Candidate.new(2, "Bill Jones")
    ],
    next_id: 3
  )

  def run() do
    %Election{}
    |> run()
  end

  def run(:quit), do: :quit

  def run(election = %Election{}) do
    [
      clear_hack(),
      clear_hack(),
      clear_hack(),
      clear_hack()
    ]
    |> IO.write()

    election
    |> view()
    |> IO.write()

    cmd = IO.gets(">")

    election
    |> update(cmd)
    |> run()
  end

  def update(election, cmd) when is_binary(cmd) do
    update(election, String.split(cmd))
  end

  def update(election, ["n" <> _ | args]) do
    name = Enum.join(args, " ")
    %{election | name: name}
  end

  def update(election, ["a" <> _ | args]) do
    name = Enum.join(args, " ")
    candidate = Candidate.new(election.next_id, name)
    candidates = [candidate | election.candidates]
    %{election | candidates: candidates, next_id: election.next_id + 1}
  end

  def update(_election, ["q" <> _]), do: :quit

  def update(election, ["v" <> _, id]) do
    vote(election, Integer.parse(id))
  end

  defp vote(election, {id, ""}) do
    candidates =
      election.candidates
      |> Enum.map(&maybe_inc_votes(&1, id))

    %{election | candidates: candidates}
  end

  defp vote(election, _errors), do: election

  def view(election) do
    [
      view_header(election),
      view_body(election),
      view_footer()
    ]
  end

  def view_body(election) do
    election.candidates
    |> sort_by_votes_desc()
    |> candidates_to_string()
    |> prepend_header_to_candidates()
  end

  def view_header(election) do
    [
      "Election for: #{election.name}\n"
    ]
  end

  def view_footer() do
    [
      "\n",
      "commands: (n)ame <election>, (a)dd <candidate>, (v)ote <id>, (q)uit\n"
    ]
  end

  def sort_by_votes_desc(candidates) do
    candidates
    |> Enum.sort(&(&1.votes >= &2.votes))
  end

  defp maybe_inc_votes(candidate, id) when is_integer(id) do
    maybe_inc_votes(candidate, candidate.id == id)
  end

  defp maybe_inc_votes(candidate, _inc_vote = false), do: candidate

  defp maybe_inc_votes(candidate, _inc_vote = true) do
    Map.update!(candidate, :votes, &(&1 + 1))
  end

  def prepend_header_to_candidates(candidates) do
    [
      "ID\tVotes\tName\n",
      "--------------------------------\n"
      | candidates
    ]
  end

  def candidates_to_string(candidates) do
    candidates
    |> Enum.map(fn %{id: id, name: name, votes: votes} ->
      "#{id}\t#{votes}\t#{name}\n"
    end)
  end

  def clear_hack() do
    "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
  end
end
