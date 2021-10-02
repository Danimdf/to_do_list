defmodule ToDoList do
  #name of file
  def start do
    file = IO.gets("Name of .txt to load: ") |> String.trim
    read(file)
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
