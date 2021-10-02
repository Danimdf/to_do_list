defmodule ToDoList do
  #read a file .txt with the content
  def start do
    file = IO.gets("Name of .txt to load: ") |> String.trim
    read(file)
  end

  def read(file) do
    case File.read(file) do
      {:ok, body}       -> body
      {:error, reason} -> IO.puts ~s(file invalid "#{file}"\n)
                          IO.inspect reason
    end
  end
end
