Code.require_file("dictionary.ex", "./")

defmodule GithubDrawing do
  @commit_count 70
  @relative_git_dir "../draw"

  def draw() do
    string_to_expected_output("h4ppyr0gu3 '24")
    |> validate_string()
    |> validate_date()
    |> commit_to_github()
  end

  def validate_string(display_array) do
    if Enum.all?(display_array, fn string -> String.length(string) <= 50 end) &&
         all_same?(
           Enum.map(display_array, fn string ->
             String.length(string)
           end)
         ) do
      display_array
    else
      raise("string is too long")
    end
  end

  def all_same?(list) do
    Enum.uniq(list) |> length() == 1
  end

  def validate_date(display_array) do
    week_of_year = ceil(Date.day_of_year(Date.utc_today()) / 7)
    day_of_week = Date.day_of_week(Date.utc_today())

    if week_of_year < 50 &&
         week_of_year > 1 &&
         day_of_week < 7 &&
         day_of_week > 1 do
      index = day_of_week - 2
      string = Enum.at(display_array, index)

      case String.at(string, week_of_year - 2) do
        "█" -> true
        _ -> false
      end
    else
      false
    end
  end

  def commit_to_github(false) do
    IO.puts("nothing to do today")
    :ok
  end

  def commit_to_github(true) do
    cwd = File.cwd()
    File.cd!(@relative_git_dir)

    Enum.each(1..@commit_count, fn iteration ->
      name = Date.to_string(Date.utc_today()) <> " " <> Integer.to_string(iteration)

      {_, result} = System.cmd("git", ["commit", "-m", name, "--allow-empty"])
      if result != 0, do: raise("git commit failed")
      {_, result} = System.cmd("git", ["push", "origin", "master"])
      if result != 0, do: raise("git push failed")
    end)

    File.cd!(cwd)
  end

  def string_to_expected_output(string) do
    output_string = String.split(string, "")
    |> Enum.reject(fn letter -> letter == "" end)
    |> concatenate_letters()

    Enum.map(output_string, fn line -> IO.puts(line) end)

    output_string
  end

  def concatenate_letters(letters) do
    Enum.map(0..4, fn idx ->
      Enum.join(
        Enum.map(letters, fn letter ->
          Enum.at(Dictionary.character_map()[letter], idx)
        end),
        " "
      )
    end)
  end
end

GithubDrawing.draw()
