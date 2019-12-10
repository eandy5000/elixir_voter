defmodule Election do
  defstruct(
    name: "Dog Catcher",
    candidates: [
      Candidate.new(1, "John Smith"),
      Candidate.new(2, "Jon Pertwee")
    ],
    next_id: 3,
    display_error: ""
  )

  def run() do
    %Election{} |> run()
  end

  def run(election = %Election{}) do
    [clear_hack()]
    |> IO.write()

    election
    |> view()
    |> IO.write()

    command = IO.gets(">")

    election
    |> update(command)
    |> run()

  end

  def clear_hack() do
    "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
  end

  def update(election, cmd) when is_binary(cmd) do
    update(election, String.split(cmd))
  end

  def update(election, ["n" <> _| args]) do
   name = Enum.join(args, " ")
   %{election | name: name}
  end

  def update(election, ["a" <> _ | args]) do
    name = Enum.join(args, " ")
    candidate = Candidate.new(election.next_id, name)
    candidates = [candidate | election.candidates]
    %{election | candidates: candidates, next_id: election.next_id + 1}
  end

  def update(election, ["v" <> _ , id]) do
    vote(election, Integer.parse(id))
  end

  def vote(election, {id, ""}) do
    candidates = election.candidates
    |> Enum.map(&maybe_inc_votes(&1,id))
    %{election | candidates: candidates}
  end

  def maybe_inc_votes(candidate, id) when is_integer(id) do
    maybe_inc_votes(candidate, candidate.id == id)
  end

  def maybe_inc_votes(candidate, _id = false), do: candidate

  def maybe_inc_votes(candidate, _id = true) do
    Map.update!(candidate, :votes, &(&1 + 1 ))
  end

  def view(election) do
    [
      view_header(election),
      view_body(election),
      view_footer()
    ]
  end

  def view_body(election) do
      election.candidates
      |> sort_candidates_by_vote()
      |> candidates_to_strings()
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

  defp sort_candidates_by_vote(candidates) do
    candidates
    |> Enum.sort(&(&1.votes >= &2.votes))
  end

  defp candidates_to_strings(candidates) do
    candidates
    |> Enum.map(fn %{id: id, name: name, votes: votes} -> 
      "#{id}\t#{votes}\t#{name}\n"
    end)
  end

  defp prepend_header_to_candidates(candidates) do
    [
      "ID\tVotes\tName\n",
      "-----------------------------\n"
      | candidates

    ]
  end

end
