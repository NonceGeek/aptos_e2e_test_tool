defmodule MoveE2ETestTool.CmdSpliter do
    import NimbleParsec
  
    @moduledoc """
      aptos CLI commands:
        $ aptos move init
    """
  
    aptos_signal =
      string("aptos")
  
    aptos_move_signal =
      string("aptos move")
    space = ascii_string([?\s], min: 0) |> ignore()
    account_signal =
      string("account")
      |> ignore(space)
    

    # --- the sub commands of account ---
    fund_with_faucet_signal =
      string("fund-with-faucet")
      |> ignore(space)
    
    transfer_signal =
      string("transfer")
      |> ignore(space)
    # --- end ---

    init_signal =
      string("init")
      |> ignore(space)
  
    defparsec :cmd,
      choice([
        aptos_move_signal,
        aptos_signal
      ])
      |> ignore(space)
      |> optional() # behaviours

    defparsec :parse_sub_aptos,
      choice([
        init_signal,
        account_signal
      ])

    defparsec :parse_sub_aptos_move,
      choice([
        init_signal,
        account_signal
      ])
    
    defparsec :parse_account,
      choice([
        fund_with_faucet_signal,
        transfer_signal
      ])

    def parse_cmd(cmd_str) do
      with {:ok, payload, others, _, _, _} <- cmd(cmd_str) do
        {[first_arg], _} = Enum.split(payload, 1)
        do_parse_cmd(first_arg, others)
      end
    end

    def do_parse_cmd("aptos", others) do
      {:ok, sub_cmd, payload, _, _, _} = parse_sub_aptos(others)
      case sub_cmd do
        ["init"] ->
          # parse init.
          # only support --priv "pr" --profile "p" for the mvp version.
          splitted_payload = String.split(payload)
          case splitted_payload do
            ["--priv", priv, "--profile", profile_name] -> 
              {"aptos", "init", %{priv: priv, profile: profile_name}}
            ["--profile", profile_name] -> 
              {"aptos", "init", %{profile: profile_name}}
          end

        ["account"] ->
          # parse account.
          {:ok, sub_cmd, sub_payload, _, _, _} = parse_account(payload)
          case sub_cmd do
            ["transfer"] ->
              # parse transfer.
              # only support --profile --account --amount for the mvp version.
              ["--profile", profile_name, "--account", account, "--amount", amount] = String.split(sub_payload)
              {
                "aptos", "account", "transfer", 
                %{profile_name: profile_name, account: account, amount: amount}
              }
            ["fund-with-faucet"] ->
              # parse fund-with-faucet.
              # only support --profile for the mvp version.
              ["--profile", profile_name] = String.split(sub_payload)
              {"aptos", "account", "fund-with-faucet", %{profile_name: profile_name}}
          end

        others ->
          {"aptos", others, payload}
      end
    end


    def do_parse_cmd("aptos move", others) do
      {"aptos move", parse_sub_aptos_move(others)}
    end
   
    # def do_parse_cmd("aptos", params), do: handle_aptos(params)
    # def do_parse_cmd("aptos move", params), do: handle_aptos_move(params)
  
    # def handle_aptos(params) do
    #   aptos
    # end
  
    # def handle_aptos_move(params) do
    #   :aptos_move
    # end
  end
  