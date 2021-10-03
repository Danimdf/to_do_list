defmodule ToDoList do
  #name of file
  def start do
    file = IO.gets("Name of .txt to load: ") |> String.trim
    read(file)
    |> parse
    |> get_command
  end

  def get_command(data) do
    prompt = """
Type the first letter of the command you want to run
R)ead Todos    A)dd a Todo    D)elete a Todo    L)oad a .csv    S)ave a .csv
"""
    command = IO.gets(prompt)
      |> String.trim
      |> String.downcase

    case command do
      "r" -> show_todos(data)
      "d" -> delete_todo(data)
      "q" -> "Goodbye!"
      _   -> get_command(data)
    end
  end

  def delete_todo(data) do
    todo = IO.gets("Which todo would you like to delete?\n") |> String.trim
    if Map.has_key? data, todo do
      IO.puts "ok."
      new_map = Map.drop(data, [todo])
      IO.puts ~s("#{todo}" has been deleted.)
      get_command(new_map)
    else
      IO.puts ~s("There is no Todo named "#{todo}"!)
      show_todos(data, false)
      delete_todo(data)
    end
  end

#read a file .csv with the content
  def read(file) do
    case File.read(file) do
      {:ok, body}       -> body
      {:error, reason} -> IO.puts ~s(file invalid "#{file}"\n)
                          IO.puts ~s("#{:file.format_error reason}"\n)
                          start()
    end
  end

  #parse data with comma
  def parse(body) do
    [header | lines] = String.split(body, ~r{(\r\n|\r|\n)})
    titles = tl String.split(header, ",")
    parse_lines(lines, titles)
  end

  #parse data in lines
  def parse_lines(lines, titles) do
    Enum.reduce(lines, %{}, fn line, built ->
      [name | fields] = String.split(line, ",")
      if Enum.count(fields) == Enum.count(titles) do
        line_data = Enum.zip(titles, fields) |> Enum.into(%{})
        Map.merge(built, %{name => line_data})
      else
        built
      end
    end)
  end

  def show_todos(data, next_command? \\ true) do
    items = Map.keys data
    IO.puts "You have the following Todos:\n"
    Enum.each items, fn item -> IO.puts item end
    IO.puts "\n"
    if next_command? do
      get_command(data)
    end
  end
end
