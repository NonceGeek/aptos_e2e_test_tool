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
$  ./aptos_e2e_test_tool --file sui_client.script
===> %{"args" => ["secp256k1"], "cli" => "sui_client", "cmd" => "new-address"}
.... {:ok,
 %Web3MoveEx.Sui.Account{
   sui_address: <<137, 218, 204, 199, 209, 235, 161, 138, 179, 150, 225, 200,
     157, 56, 123, 75, 184, 218, 49, 66, 121, 65, 182, 185, 34, 83, 249, 212, 3,
     51, 76, 107>>,
   sui_address_hex: "0x89daccc7d1eba18ab396e1c89d387b4bb8da31427941b6b92253f9d403334c6b",
   priv_key: <<1, 34, 61, 164, 216, 33, 36, 105, 253, 99, 86, 203, 81, 85, 80,
     34, 79, 121, 215, 199, 242, 46, 38, 186, 24, 210, 159, 238, 152, 201, 77,
     221, 155>>,
   priv_key_base64: "ASI9pNghJGn9Y1bLUVVQIk9518fyLia6GNKf7pjJTd2b",
   key_schema: "secp256k1",
   phrase: "nature gallery eternal glance weather short risk barely fog scene stairs shallow reveal thing parade attract hobby traffic eye antenna round hotel carry orphan"
 }}


===> %{"args" => ["AAumH4YpXBOdglwNPalFGbj6btlTwOeAcAJscyfl4A4H"], "cli" => "sui_client", "cmd" => "import-address"}
.... :ok



17:47:44.739 [warning] Description: 'Authenticity is not established by certificate path validation'
     Reason: 'Option {verify, verify_peer} and cacertfile/cacerts is missing'

===> %{"cli" => "sui_client", "cmd" => "gas"}
.... []

```
Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/aptos_e2e_test_tool>.

