# Providers & Model Aliases

Set via `hermes model` (picker) or `hermes setup`. 35+ provider profiles ship as
plugins under `plugins/model-providers/`; user plugins of the same name override.
Full docs: https://hermes-agent.nousresearch.com/docs/integrations/providers

### Providers

| Provider | Auth | Key env var(s) |
|----------|------|----------------|
| openrouter | API key | `OPENROUTER_API_KEY` |
| anthropic | API key | `ANTHROPIC_API_KEY` (also `CLAUDE_CODE_OAUTH_TOKEN`) |
| nous | OAuth device code | `hermes auth add nous` (or `NOUS_API_KEY`) |
| openai-codex | OAuth | `hermes auth add openai-codex` |
| qwen-oauth | Existing cached Qwen CLI credentials only | `hermes auth add qwen-oauth` imports a usable existing cache; new OAuth logins are discontinued |
| minimax-oauth | OAuth | `hermes auth add minimax-oauth` |
| copilot | Token | `COPILOT_GITHUB_TOKEN` / `GH_TOKEN` (Copilot device flow — `gh auth login` tokens do NOT work) |
| copilot-acp | External CLI | Copilot CLI on PATH or `COPILOT_CLI_PATH` |
| gemini | API key | `GOOGLE_API_KEY` or `GEMINI_API_KEY` |
| xai | API key | `XAI_API_KEY` (SuperGrok OAuth also supported) |
| deepseek | API key | `DEEPSEEK_API_KEY` |
| zai (GLM) | API key | `GLM_API_KEY` / `ZAI_API_KEY` |
| minimax / minimax-cn | API key | `MINIMAX_API_KEY` / `MINIMAX_CN_API_KEY` |
| kimi-coding / -cn | API key | `KIMI_API_KEY` / `KIMI_CN_API_KEY` |
| alibaba (+coding-plan) | API key | `DASHSCOPE_API_KEY` / `ALIBABA_CODING_PLAN_API_KEY` |
| xiaomi | API key | `XIAOMI_API_KEY` |
| huggingface | Token | `HF_TOKEN` |
| fireworks / novita / nvidia / deepinfra / gmi / arcee / stepfun / upstage / kilocode / ai-gateway / opencode-zen / opencode-go / ollama-cloud | API key | `<NAME>_API_KEY` |
| bedrock / vertex / azure-foundry | Cloud SDK / key | AWS SDK creds / Vertex ADC / `AZURE_FOUNDRY_API_KEY` |
| custom | API key, or unauthenticated local server | `model.base_url` is a setting; keep actual `OPENAI_API_KEY` credentials in the active profile's `.env` |

Multiple credentials per provider pool and rotate automatically (`hermes auth`).
Fallback chain when the primary fails: `hermes fallback add|remove|list`.

### Switching a WhatsApp chat to the ChatGPT subscription

Send this as its own WhatsApp message:

```text
/model gpt-6.1-sol --provider openai-codex
```

Then send `/status` to verify the active session model/provider. `/reasoning medium` changes the session's effort; use high/xhigh only when requested or warranted. Add `--global` to the model command only when the user wants to change the persistent default, not merely this chat. Explicitly routed running subagents keep their own model; a chat switch is not a request to reroute their pipeline.

For automatic backup instead, run `hermes fallback add` in a terminal and choose the subscription provider/model. Read back `hermes fallback list` and `hermes config get model`: the picker may print a temporary default-selection message while the resulting configuration still keeps the original primary. Distinguish **configured fallback**, **persistent default**, and **active session**. An installed fallback is tried after eligible failures; it does not establish that a particular WhatsApp reply used it. Use runtime/session metadata, not prose self-identification from an earlier reply, to confirm active routing.

### Local-server verification

- Check the installed Hermes context minimum before choosing a server buffer.
  Hermes 0.21.2 rejects a declared context below 64,000 tokens before its first
  API request. Provision a genuine server context (for example 65,536), then
  set `model.context_length` to the same value; never inflate the declaration
  just to bypass the guard. A healthy `/v1/models` response alone misses this.
- A cloned profile can inherit hosted fallbacks, auxiliary routes, MCP servers,
  memory, and CLI toolsets. Audit them separately. The CLI tool selection key
  is `platform_toolsets.cli`; setting top-level `toolsets` alone may not replace
  the inherited selection. `hermes -p <profile> prompt-size --json` reports the
  actual prompt and schema footprint.
- Prove a short chat and then a real tool-result round trip, inspecting the
  exact session's `logs/agent.log` for the intended provider/model and zero
  `Fallback activated` lines. Record latency: a local model can be technically
  functional but impractical on CPU. Do not present direct API tool calls as
  proof that Hermes executed a tool.
- Disabling main-model fallbacks does not establish a hard offline sandbox:
  auxiliary providers and tool network access are independent routes.
- `DEFAULT_CONFIG['auxiliary']` mixes task dictionaries with global scalar/list
  settings (`free_only`, `openrouter_model`, `transient_retries`,
  `stream_only_base_urls`). When bulk-pinning local routes, select only task
  dictionaries; preserve the global settings and verify their types through
  `load_config_readonly()` afterward. Verify resolved routes and discovery
  fallback policy, not merely equality with the generated write payload.
- Accelerator support is model-family-specific. Colibri's GLM Vulkan backend
  does not imply Vulkan support for DeepSeek V4 (CPU/CUDA in 1.10.2). Check the
  installed family docs/registry and `coli doctor --model <path> --gpu <id>`
  before installing build dependencies or retrying a large prompt. Confirm
  protocol tool support separately; model size and GPU availability alone
  do not prove a usable agent route.

### User-defined model aliases

Work with `/model <name>` in CLI and every gateway platform. Resolved by
`hermes_cli/model_switch.py::resolve_alias()`; user aliases are checked BEFORE
the built-in table, so a user `sonnet`/`grok` shadows the built-in.

```yaml
# Full form
model_aliases:
  fav:
    model: claude-sonnet-4.6
    provider: anthropic
  local-qwen:
    model: qwen3.5:397b
    provider: custom
    base_url: "https://ollama.com/v1"

# Short form ("provider/model"), also via CLI:
#   hermes config set model.aliases.fav openrouter/anthropic/claude-sonnet-4.6
model:
  aliases:
    fav: openrouter/anthropic/claude-sonnet-4.6
```

`/model fav` — session-scoped; add `--global` to persist as default.

Built-in aliases (catalog-resolved against the active provider): `sonnet`,
`opus`, `haiku`, `claude`, `gpt5`, `gpt`, `codex`, `o3`, `o4`, `gemini`,
`deepseek`, `grok`, `llama`, `qwen`, `minimax`, `nemotron`, `kimi`, `glm`,
`step`, `mimo`, `trinity`.
