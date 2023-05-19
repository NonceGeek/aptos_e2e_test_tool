defmodule MoveE2ETestTool.CliParser do
  alias Web3AptosEx.Aptos
  alias Web3MoveEx.Sui
  alias MoveE2ETestTool.AptosCliParser
  alias MoveE2ETestTool.CmdSpliter
  @moduledoc """
  """
  # def main(["--file", file]) do
  #   {:ok, script} = File.read(file)
  #   {:ok, _} = Application.ensure_all_started(:web3_move_ex)
  #   run(script, file)
  # end
  # def run(script, file \\ "tmp.script") do
  #   m = file_to_module(file)
  #   code = SuiCliParser.parse_script_to_code(script, m)
  #   :ok = :file.write_file(:filename.rootname(file) <> ".ex", code)
  #   Code.eval_string(code)
  #   {:ok, agent} = start()
  #   apply(String.to_atom("Elixir.MoveE2ETestTool." <> m), :run, [agent])
  # end

  def start(network_type) do
    {:ok, client} = Aptos.connect(network_type)
    {:ok, pid} = Agent.start_link(fn -> %{client: client} end)
    Process.register(pid, :aptos_client)
  end

  def exec_cmd(%{cli: :code, line: code_line}) do
    code_line
    |> CmdSpliter.parse_cmd()
    |> do_exec_cmd()
  end

  # --- aptos move commands ---
  def do_exec_cmd({"aptos move", sub_cmd, payload}) do
    
  end
  # --- end ---

  # --- aptos commands ---
  def do_exec_cmd({"aptos", "init", %{priv: priv, profile: profile_name}}) do 
    {:ok, acct} = Web3AptosEx.Aptos.generate_keys(priv)
    pid = Process.whereis(:aptos_client)
    Agent.update(pid, fn payload -> Map.put(payload, String.to_atom(profile_name), %{acct: acct}) end)
  end

  def do_exec_cmd({"aptos", "init", %{profile: profile_name}}) do 
    {:ok, acct} = Web3AptosEx.Aptos.generate_keys()
    pid = Process.whereis(:aptos_client)
    Agent.update(pid, fn payload -> Map.put(payload, String.to_atom(profile_name), %{acct: acct}) end)
  end
  
  def do_exec_cmd({"aptos", "account", "transfer", _sth}) do 
    :transfer
  end

  @doc """
    result format:

    ```
      {:ok, ["72f3229a4e9ad41f7ceb5f59dadfaac76200708511657452cd488b1739ab651d"]}
    ```
  """
  def do_exec_cmd({"aptos", "account", "fund-with-faucet", %{profile_name: profile_name}}) do 
    payload = get_info()
    %{acct: acct} = Map.get(payload, String.to_atom(profile_name))
    %{client: client} = payload
    Web3AptosEx.Aptos.get_faucet(client, acct.address_hex)
  end

  def do_exec_cmd({"aptos", "account", "transfer",  %{profile_name: profile_name, account: account, amount: amount}) do 
    payload = get_info()
    %{acct: acct} = Map.get(payload, String.to_atom(profile_name))
    %{client: client} = payload
    Web3AptosEx.Aptos.get_faucet(client, acct.address_hex)
  end
  # --- end ---

  def get_info() do
    pid = Process.whereis(:aptos_client)
    Agent.get(pid, (&(&1)))
  end
  
  def cmd(agent, %{"cli" => "sui_client", "cmd" => "new-address", "args" => [key_schema | _]}) do
    {:ok, acct} = Web3MoveEx.Sui.gen_acct(String.to_atom(key_schema))
#    {:ok, acct} =
#      {:ok,
#       %Web3MoveEx.Sui.Account{
#         sui_address:
#           <<173, 247, 138, 113, 25, 16, 185, 209, 222, 3, 2, 38, 31, 18, 48, 156, 136, 2, 245,
#             243, 0, 205, 170, 16, 200, 119, 17, 120, 234, 150, 208, 145>>,
#         sui_address_hex: "0xadf78a711910b9d1de0302261f12309c8802f5f300cdaa10c8771178ea96d091",
#         priv_key:
#           <<0, 11, 166, 31, 134, 41, 92, 19, 157, 130, 92, 13, 61, 169, 69, 25, 184, 250, 110,
#             217, 83, 192, 231, 128, 112, 2, 108, 115, 39, 229, 224, 14, 7>>,
#         priv_key_base64: "AAumH4YpXBOdglwNPalFGbj6btlTwOeAcAJscyfl4A4H",
#         key_schema: "ed25519",
#         phrase:
#           "city record reject glow similar misery finger tongue wage diesel high prevent end gadget pill tiny shine muffin prefer coffee custom shell quantum office"
#       }}

    Agent.update(agent, fn dict ->
      Map.put(dict, :acct, acct)
    end)

    {:ok, acct}
  end

  def cmd(agent, %{"cli" => "sui_client", "cmd" => "new-address"} = cmd) do
    cmd(agent, Map.put(cmd, "args", ["ed25519"]))
  end

  def cmd(agent, %{"cli" => "sui_client", "cmd" => "gas"}) do
    %{client: client, acct: acct} = Agent.get(agent, fn state -> state end)
    {:ok, %{data: data}} = Web3MoveEx.Sui.get_all_coins(client, acct.sui_address_hex)
    data
  end

  def cmd(agent, %{
        "cli" => "sui_client",
        "cmd" => "call",
        "package" => [package],
        "function" => [function],
        "module" => [module],
        "args" => args,
        "gas" => [gas],
        "gas-budget" => [gas_budget]
      }) do
    %{client: client, acct: acct} = Agent.get(agent, fn state -> state end)
    client |> Sui.move_call(acct, package, module, function, [], args, gas, gas_budget)
  end

  def cmd(
        agent,
        %{
          "cli" => "sui_client",
          "cmd" => "call",
          "package" => package,
          "function" => function,
          "module" => module,
          "args" => args,
          "gas-budget" => gas_budget
        } = params
      ) do
    cmd(agent, Map.put(params, "gas", [nil]))
  end

  @doc """
    "sui client transfer-sui --to 0x181bd292dbe70628479b85e873460caa3e180fe2 --sui-coin-object-id 0x82db13db77f034873cf3f1f2e43fc1237e08664e --gas-budget 30000"
  """
  def cmd(agent, %{
        "cli" => "sui_client",
        "cmd" => "transfer-sui",
        "gas-budget" => [gas_budget],
        "sui-coin-object-id" => [sui_coin_object_id],
        "to" => [to]
      }) do
    %{client: client, acct: acct} = Agent.get(agent, fn state -> state end)
    Sui.unsafe_transfer(client, acct, sui_coin_object_id, gas_budget, to)
  end
  def cmd(agent, %{
  "cli" => "sui_client",
  "cmd" => "import-address",
  "args" => args
  }) do
   addresses = args |> Enum.map(fn x -> Web3MoveEx.Sui.Account.from(x)  end)
   Agent.update(agent, fn dict ->
      Map.put(dict, :addresses, addresses)
      Map.put(dict, :acc, :erlang.hd(addresses))
    end)
  end
  defp file_to_module(file) when is_binary(file) do
    name = :filename.rootname(file)
     [a|rest] = name1 = to_charlist(name)
     String.upcase(List.to_string([a])) <> change_module(rest, "")
    end

  defp change_module([], acc) do
    acc
    end
    defp change_module([?_, f| rest], acc) do
        change_module(rest, acc <> String.upcase(List.to_string([f])))
    end
    defp change_module([f| rest], acc) do
    change_module(rest, acc <> List.to_string([f]))
    end
end
