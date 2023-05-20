# AptosE2ETestTool

Aptos E2E Test Tool based on [Web3AptosEx](https://github.com/NonceGeek/web3_aptos_ex), and offline implementation for End-2-End Aptos Smart Contract Test Tool.

It can test aptos smart contract with script like this:

```
# ex-script: set-network testnet
# init account.
aptos init --profile leeduckgo
# get some faucet.
aptos account fund-with-faucet --profile leeduckgo
aptos account get-balance --profile leeduckgo
# ex-script: assert "aptos account get-balance --profile leeduckgo" ==  %{coin: %{value: "100000000"}}
......
```

the script is combined with aptos cli command, annotate & ex-script like `assert`,  so this tool is very friendly for Aptos developers to writing `e2e test script`! 

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `aptos_e2e_test_tool` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:aptos_e2e_test_tool, "~> 0.1.0"}
  ]
end
```
## Build and Test
```shell
$ mix escript.build
$  ./aptos_e2e_test_tool --file example.script
...
```
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/aptos_e2e_test_tool>.

