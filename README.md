# AptosE2ETestTool

Aptos E2E Test Tool based on [Web3AptosEx](https://github.com/NonceGeek/web3_aptos_ex), and offline implementation for End-2-End Aptos Smart Contract Test Tool.

It can test aptos smart contract with script like this:

```
# -[acct operations]-

# ex-script: set-network testnet
# init account.
aptos init --priv 0xb46737230c6037ac1c5efcf67c1ba039947eaf354d3960851df55ed3abd2eb9c --profile leeduckgo
# get some faucet.
aptos account fund-with-faucet --profile leeduckgo
aptos account get-balance --profile leeduckgo

# -[contract test]-
# contract addr: 0xcd6e69ff3c22db037584f b1650f7ca75df721fb0143690fb33f2f3bd0c1fe5bd
# network: testnet
# contract name: hello_blockchain

# run the set message
aptos move run --function-id 0xcd6e69ff3c22db037584fb1650f7ca75df721fb0143690fb33f2f3bd0c1fe5bd::message::set_message --profile leeduckgo --args string:Hello_World
aptos account list --query resources --profile leeduckgo
# ex-script: sleep 2s
# ↓ this cmd should return true ↓
# default profile
# ex-script: assert "message" of leeduckgo in "0xcd6e69ff3c22db037584fb1650f7ca75df721fb0143690fb33f2f3bd0c1fe5bd::message::MessageHolder" == "Hello_World"

aptos move run --function-id 0xcd6e69ff3c22db037584fb1650f7ca75df721fb0143690fb33f2f3bd0c1fe5bd::message::set_message  --profile leeduckgo --args string:Hello_Aptos
# ex-script: sleep 2s
# ↓ this cmd should return false ↓
# default profile
# ex-script: assert "message" of leeduckgo in "0xcd6e69ff3c22db037584fb1650f7ca75df721fb0143690fb33f2f3bd0c1fe5bd::message::MessageHolder" == "Hello_World"
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

## Distributed Rule

<!-- distributed_rules -->

Linked Repos:

```
https://github.com/NonceGeek/web3_aptos_ex, 20%
self, 80%
```

Contributors:

```
pool, 20%
https://github.com/leeduckgo, 40%
https://github.com/yangcancai, 40%
```

<!-- / distributed_rules -->
