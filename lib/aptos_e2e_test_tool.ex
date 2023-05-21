defmodule AptosE2ETestTool do
  @moduledoc """
  Documentation for `AptosE2ETestTool`.
  """
  alias AptosE2ETestTool.ScriptParser
  alias AptosE2ETestTool.CliParser
  require Logger

  def main(args) do
    {opts, _, _} =
      OptionParser.parse(args,
        strict: [file: :string],
        aliases: [f: :file_name])
    opts |> deal_opts()
  end
  
  def deal_opts([file: file_name]) do
    run(file_name)
  end

  def run(file_name) do
    {cmds, _} =
      ScriptParser.parse_script_from_file(file_name)
    Enum.map(cmds, fn cmd ->
      # handle cmd one by one.
      res = CliParser.exec_cmd(cmd)
      Logger.info("#{inspect(cmd)} => #{inspect(res)}")
    end)
  end
  def web_run(content) do
    cmds =
      ScriptParser.parse_script_to_clis(content)
    Enum.map(cmds, fn cmd ->
      # handle cmd one by one.
      res = CliParser.exec_cmd(cmd)
      "#{inspect(cmd)} => #{inspect(res)}"
    end) |> Enum.reduce("", fn x,acc -> "#{acc}<br/>#{x}" end)
  end
end
