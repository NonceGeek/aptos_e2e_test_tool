defmodule AptosE2ETestTool.CliParser do
  alias Web3AptosEx.Aptos
  alias AptosE2ETestTool.CmdSpliter

  import Web3AptosEx.Aptos
  require Logger

  def start(network_type) do
    {:ok, client} = Aptos.connect(network_type)
    {:ok, pid} = Agent.start_link(fn -> %{client: client} end)
    Process.register(pid, :aptos_client)
  end

  def exec_cmd(%{cli: :comment, line: "# ex-script: set-network testnet"}) do
    start(:testnet)
  end

  def exec_cmd(%{cli: :comment, line: "# ex-script: set-network mainnet"}) do
    start(:mainnet)
  end

  def exec_cmd(%{cli: :comment, line: "# ex-script: sleep 2s"}) do
    Process.sleep(2000)
  end

  def exec_cmd(%{cli: :comment, line: line}) do
    {prefix, ex_script} = String.split_at(line, 12)
    case prefix do
      "# ex-script:" ->
        exec_ex_cmd(ex_script)
      _others ->
        :pass
    end
  end

  @doc """
    only parse after cmd in mvp version:
    ```
      assert "message" in "0xcd6e69ff3c22db037584fb1650f7ca75df721fb0143690fb33f2f3bd0c1fe5bd::message::MessageHolder" == "Hello_World"
    ```
  """
  def exec_ex_cmd(ex_script) do
    ["assert", key, "of", profile_name, "in", resource_path, "==", var] = String.split(ex_script)
    info = get_info()
    %{acct: acct} = Map.get(info, String.to_atom(profile_name))
    %{client: client} = info
    resource_path = String.replace(resource_path, "\"", "")
    var = String.replace(var, "\"", "")
    key = String.replace(key, "\"", "")
    {:ok, payload} = Aptos.get_resource(client, acct.address_hex, resource_path)
    payload
    |> Map.get(:data)
    |> Map.get(String.to_atom(key))
    |> Kernel.==(var)

  end

  def exec_cmd(%{cli: :code, line: code_line}) do
    code_line
    |> CmdSpliter.parse_cmd()
    |> case do
      :pass ->
        :pass
      others ->

        do_exec_cmd(others)
    end
  end

  # --- aptos move commands ---
  def do_exec_cmd({"aptos move", "run", payload}) do
    func_id = Map.fetch!(payload, "function-id")
    args_raw = Map.fetch!(payload, "args")
    profile_name = Map.fetch!(payload, "profile")
    # TODO: implementation of type-args
    # ~a"0x1::coin::transfer<CoinType>(address, u64)"
    {arg_types, arg_values} = handle_args(args_raw) 
    {:ok, f} = ~a"#{func_id}(#{arg_types})"
    payload = Aptos.call_function(f, [], arg_values)

    info = get_info()
    %{acct: acct} = Map.get(info, String.to_atom(profile_name))
    %{client: client} = info
    {:ok, acct_preloaded} =Aptos.load_account(client, acct)

    Aptos.submit_txn(client, acct_preloaded, payload)
  end
  
  # --- end ---

  def handle_args(args_raw) when is_binary(args_raw) do
    [type, value] = String.split(args_raw, ":", parts: 2)
    {type, [value]}
  end
  def handle_args(args_raw) when is_list(args_raw) do
    types =
      args_raw
      |> Enum.map(fn arg ->
        [type, _value] = String.split(arg, ":", parts: 2)
        type
      end)
      |> Enum.reduce("", fn type, acc ->
        "#{acc}, #{type}"
      end)
      |> Binary.drop(2)

    values = 
      args_raw
      |> Enum.map(fn arg ->
        [_type, value] = String.split(arg, ":", parts: 2)
        value
      end)
    {types, values}
  end

  # --- aptos commands ---
  def do_exec_cmd({"aptos", "init", %{priv: priv, profile: profile_name}}) do 
    info = get_info()
    %{client: client} = info

    {:ok, acct} = Web3AptosEx.Aptos.generate_keys(priv)
    acct_loaded = 
      case Aptos.load_account(client, acct) do
        {:ok, acct_loaded} ->
          acct_loaded
        _others ->
          acct
      end
    pid = Process.whereis(:aptos_client)
    Agent.update(pid, fn payload -> Map.put(payload, String.to_atom(profile_name), %{acct: acct_loaded}) end)
    %{addr: acct.address_hex, priv: acct.priv_key_hex}
  end

  def do_exec_cmd({"aptos", "init", %{profile: profile_name}}) do 
    info = get_info()
    %{client: client} = info

    {:ok, acct} = Web3AptosEx.Aptos.generate_keys()
    acct_loaded = 
      case Aptos.load_account(client, acct) do
        {:ok, acct_loaded} ->
          acct_loaded
        _others ->
          acct
      end
    pid = Process.whereis(:aptos_client)
    Agent.update(pid, fn payload -> Map.put(payload, String.to_atom(profile_name), %{acct: acct_loaded}) end)
    %{addr: acct.address_hex, priv: acct.priv_key_hex}
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
    res = Aptos.get_faucet(client, acct.address_hex)
    Process.sleep(2000) # sleep 2 sec.
    {:ok, acct_loaded} = Aptos.load_account(client, acct)

    pid = Process.whereis(:aptos_client)
    Agent.update(pid, fn payload -> Map.put(payload, String.to_atom(profile_name), %{acct: acct_loaded}) end)
    res
  end


  """
    result format:

    ```
      {:ok,
        %{
          expiration_timestamp_secs: "1684474519",
          gas_unit_price: "1000",
          hash: "0x771cf8ed9164b0f4d7a6aafe8cfad4fb55f41f99c07cba682c7342b9333e608c",
          max_gas_amount: "2000",
          payload: %{
            arguments: ["0x2df41622c0c1baabaa73b2c24360d205e23e803959ebbcb0e5b80462165893ed",
              "100"],
            function: "0x1::coin::transfer",
            type: "entry_function_payload",
            type_arguments: ["0x1::aptos_coin::AptosCoin"]
          },
          sender: "0x1fe4a4a607c125fce5aefa12a28d53a9383ad1d35fb8044ee42698db5aaab9ff",
          sequence_number: "0",
          signature: %{
            public_key: "0xa3642f14f12d323c646f49419df536b3f2b06d571aee32870ebb6906eefae41a",
            signature: "0xe3712a27ea90be18de895fa97349ba1b206ebf295091d38b769c1a30573e4e558e72f8fcf58d806d33ee1994c7aacf224792fa1eb558bec98b5ef2646dbd4503",
            type: "ed25519_signature"
          }
        }}   
    ```
  """
  def do_exec_cmd({"aptos", "account", "transfer",  %{profile_name: profile_name, account: to, amount: amount}}) do 
    payload = get_info()
    %{acct: acct} = Map.get(payload, String.to_atom(profile_name))
    %{client: client} = payload
    Aptos.transfer(client, acct, to, String.to_integer(amount))
  end

  def do_exec_cmd({"aptos", "account", "get-balance", %{profile_name: profile_name}}) do
    payload = get_info()
    %{acct: acct} = Map.get(payload, String.to_atom(profile_name))
    %{client: client} = payload
    Aptos.get_balance(client, acct.address_hex)
  end

  def do_exec_cmd({"aptos", "account", "list --query resources", %{profile_name: profile_name}}) do
    payload = get_info()
    %{acct: acct} = Map.get(payload, String.to_atom(profile_name))
    %{client: client} = payload
    Aptos.get_resources(client, acct.address_hex)
  end
  # --- end ---

  def get_info() do
    pid = Process.whereis(:aptos_client)
    Agent.get(pid, (&(&1)))
  end
end
