defmodule Election do
  defstruct(
    name: "Dog Catcher",
    candidates: [
      Candidate.new(1, "Joe Smith"),
      Candidate.new(2, "Bill Davis")
    ],
    next_id: 3
  )

  def run() do
    %Election{} |> run()
  end

  def run(:quit), do: :quit

  def run(election = %Election{}) do
    [
      hack_clear()
    ]
    |> IO.write()

    election
    |> view()
    |> IO.write()

    cmd = IO.gets(" > ")

    election
    |> update(cmd)
    |> run()
  end

  def update(election, cmd) when is_binary(cmd) do
    update(election, String.split(cmd))  
  end

  def update(_election, ["q" <> _ | _args]), do: :quit

  def update(election, ["n" <> _ | args]) do
    name = Enum.join(args, " ")
    %{election | name: name}
  end

  def update(election, ["a" <> _ | args]) do
    name = Enum.join(args, " ")
    candidate = Candidate.new(election.next_id, name)
    candidates = [candidate | election.candidates]

    # %{election | candidates: candidates, next_id: election.next_id}
    election
    |> Map.put(:candidates, candidates)
    |> Map.put(:next_id, election.next_id + 1)
  end


  def update(election, ["v" <> _ , id]) do
    vote(election, Integer.parse(id))
  end

  def update(election, _errors), do: election


  def vote(election, {id, ""}) do
    candidates = Enum.map(election.candidates, &maybe_inc_vote(&1, id))
    %{election | candidates: candidates}
  end

  def vote(election, _errors), do: election

  def view(election) do
    [
      view_header(election),
      view_body(election),
      view_footer()
    ]
  end

  defp view_body(election) do
    election.candidates
    |> sort_by_votes_desc()
    |> candidates_to_string()
    |> prepend_header_to_candidates()
  end

  defp view_header(election) do
    [
      "Election for: #{election.name}\n"
    ]
  end

  defp view_footer() do
    [
      "\n",
      "(n)ame <election> (a)dd <candidate> (v)ote <id> (q)uit"
    ]
  end

  defp maybe_inc_vote(candidate, id) when is_integer(id) do
    maybe_inc_vote(candidate, candidate.id == id)
  end

  defp maybe_inc_vote(candidate, _inc_vote = false), do: candidate

  defp maybe_inc_vote(candidate, _inc_vote = true) do
    candidate
    |> Map.update!(:votes, &(&1 + 1))
  end

  defp candidates_to_string(candidates) do
    candidates
    |> Enum.map(fn %{id: id, name: name, votes: votes} -> 
      "#{id}\t#{votes}\t#{name}\n"
    end)
  end

  defp sort_by_votes_desc(candidates) do
    candidates
    |> Enum.sort(&(&1.votes >= &2.votes))
  end
  
  defp prepend_header_to_candidates(candidates) do
    [
      "ID\tVOTES\tNAME\n",
      "-------------------------------------------\n"
      | candidates
    ]
  end

  defp hack_clear() do
    "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
  end

end