defmodule YeccTest do
  use ExUnit.Case
  doctest AptosE2ETestTool

  test "sui parser" do
    sui_scripts = """
       # create a sui-address
        sui client new-address
        sui client new-address e2519r
        sui client gas
      sui client transfer-sui --to 0x313c133acaf25103aae40544003195e1a3bb7d5b2b11fd4c6ec61af16bcdb968 --sui-coin-object-id 0x3a5f70f0bedb661f1e8bc596e308317edb0bdccc5bc86207b45f01db1aad5ddf --gas-budget 2000
    sui client call --function buy_ham --module sandwich --package 0x08204ed92afcfdf9d0f6727a2c7d40db93a059d8 --args args1 args2 --gas gas_obj --gas-budget 30000
      a = b
      case a do
          true -> :ok
          false -> :error
        end
      a
      |>
      b
    assert a == 1
                sui client new-address e2519r
    """

    check_sui(sui_scripts, [
      %{cli: :comment, line: "   # create a sui-address"},
      %{args: [], cli: :sui_client, cmd: :"new-address"},
      %{args: ["e2519r"], cli: :sui_client, cmd: :"new-address"},
      %{cli: :sui_client, cmd: :gas},
      %{
        cli: :sui_client,
        cmd: :"transfer-sui",
        "gas-budget": ["2000"],
        "sui-coin-object-id": ["0x3a5f70f0bedb661f1e8bc596e308317edb0bdccc5bc86207b45f01db1aad5ddf"],
        to: ["0x313c133acaf25103aae40544003195e1a3bb7d5b2b11fd4c6ec61af16bcdb968"]
      },
      %{
        args: ["args1", "args2"],
        cli: :sui_client,
        cmd: :call,
        function: ["buy_ham"],
        gas: ["gas_obj"],
        "gas-budget": ["30000"],
        module: ["sandwich"],
        package: ["0x08204ed92afcfdf9d0f6727a2c7d40db93a059d8"]
      },
      %{cli: :code, line: "  a = b"},
      %{cli: :code, line: "  case a do"},
      %{cli: :code, line: "      true -> :ok"},
      %{cli: :code, line: "      false -> :error"},
      %{cli: :code, line: "    end"},
      %{cli: :code, line: "  a"},
      %{cli: :code, line: "  |>"},
      %{cli: :code, line: "  b"},
      %{cli: :code, line: "assert a == 1"},
      %{args: ["e2519r"], cli: :sui_client, cmd: :"new-address"}
    ]
    )
  end

  def check_sui(str, expected) do
    res = AptosE2ETestTool.SuiCliParser.parse_script_to_clis(str)
    assert expected == res
  end
end
