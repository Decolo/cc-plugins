# chrome-cdp

Give your AI agent access to your live Chrome session via Chrome DevTools Protocol. Connects to tabs you already have open — no separate browser instance, no Puppeteer.

## Setup

1. Enable remote debugging in Chrome: open `chrome://inspect/#remote-debugging` and toggle the switch
2. Requires Node.js 22+

## Commands

| Command | Description |
|---------|-------------|
| `list` | List all open tabs |
| `shot <target> [file]` | Capture viewport screenshot |
| `snap <target>` | Accessibility tree snapshot |
| `html <target> [selector]` | Full page or element HTML |
| `eval <target> <expr>` | Run JavaScript in page context |
| `nav <target> <url>` | Navigate and wait for load |
| `net <target>` | Resource timing entries |
| `click <target> <selector>` | Click element by CSS selector |
| `clickxy <target> <x> <y>` | Click at CSS pixel coordinates |
| `type <target> <text>` | Type text at current focus |
| `loadall <target> <selector> [ms]` | Click "load more" until gone |
| `evalraw <target> <method> [json]` | Raw CDP command passthrough |
| `open [url]` | Open new tab |
| `stop` | Stop the browser daemon |

## Environment Variables

- `CDP_PORT_FILE` — path to `DevToolsActivePort` if in a non-standard location
- `CDP_HOST` — Chrome debugging host (default: `127.0.0.1`)
