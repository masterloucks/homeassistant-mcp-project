# Home Assistant MCP Project

This project sets up the Model Context Protocol (MCP) integration between Claude Code and Home Assistant, allowing you to control your smart home devices using natural language commands through Claude.

## Features

- Control lights, switches, fans, climate devices
- Query sensor data (temperature, humidity, motion, etc.)
- Set device positions and brightness levels
- Media player controls
- Real-time device status monitoring

## Requirements

- **Home Assistant** 2025.2+ with Long-Lived Access Token
- **Node.js** 18+ and npm
- **Claude Code** CLI tool
- **Python** 3.8+ (for MCP proxy server)

## Setup Instructions

### 1. Clone This Repository

```bash
git clone https://github.com/masterloucks/homeassistant-mcp-project.git
cd homeassistant-mcp-project
```

### 2. Install Node.js Dependencies

```bash
npm install
```

### 3. Set Up Home Assistant MCP Proxy Server

The MCP proxy server handles the communication between Claude and Home Assistant.

#### Clone the MCP Proxy Repository

```bash
git clone https://github.com/jloucks/homeassistant-mcp.git mcp-proxy
cd mcp-proxy
```

#### Install Python Dependencies

```bash
# Using uv (recommended)
uv sync

# Or using pip
pip install -e .
```

#### Configure Home Assistant Connection

1. **Create a Long-Lived Access Token in Home Assistant:**
   - Go to your Home Assistant web interface
   - Navigate to Profile → Security → Long-Lived Access Tokens
   - Click "Create Token" and give it a name like "Claude MCP"
   - Copy the generated token (you'll only see it once!)

2. **Create configuration file:**
   ```bash
   cp config_example.json config.json
   ```

3. **Edit `config.json` with your Home Assistant details:**
   ```json
   {
     "host": "http://your-homeassistant-ip:8123",
     "token": "your-long-lived-access-token-here"
   }
   ```

#### Test the MCP Server

```bash
cd mcp-proxy
uv run homeassistant_mcp
```

The server should start and connect to your Home Assistant instance.

### 4. Configure Claude Code

#### Create MCP Configuration

Create or edit your Claude Code MCP configuration file:

**On macOS/Linux:**
```bash
mkdir -p ~/.config/claude-code
cat > ~/.config/claude-code/mcp_servers.json << 'EOF'
{
  "mcpServers": {
    "homeassistant": {
      "command": "uv",
      "args": ["run", "homeassistant_mcp"],
      "cwd": "/path/to/your/homeassistant-mcp-project/mcp-proxy"
    }
  }
}
EOF
```

**On Windows:**
```cmd
mkdir %APPDATA%\claude-code
```
Then create `%APPDATA%\claude-code\mcp_servers.json` with the same content, adjusting the path accordingly.

**Important:** Replace `/path/to/your/homeassistant-mcp-project/mcp-proxy` with the actual absolute path to your mcp-proxy directory.

#### Alternative: Use the Convenience Script

You can also use the provided shell script:

```bash
# Make the script executable
chmod +x run-mcp-proxy.sh

# Edit the script to set the correct path
nano run-mcp-proxy.sh
```

Then configure Claude Code to use:
```json
{
  "mcpServers": {
    "homeassistant": {
      "command": "./run-mcp-proxy.sh",
      "cwd": "/path/to/your/homeassistant-mcp-project"
    }
  }
}
```

### 5. Test the Integration

1. **Start Claude Code:**
   ```bash
   claude-code
   ```

2. **Test Home Assistant commands:**
   - "What's the temperature in the living room?"
   - "Turn on the kitchen lights"
   - "Set the bedroom fan to 50%"
   - "Is the front door locked?"

## Troubleshooting

### Common Issues

1. **"Connection refused" or "Unauthorized"**
   - Verify your Home Assistant URL and access token
   - Ensure Home Assistant is accessible from your machine
   - Check that the token hasn't expired

2. **"Command not found" errors**
   - Ensure `uv` is installed: `pip install uv`
   - Verify Node.js and npm are installed: `node --version && npm --version`
   - Check that paths in MCP configuration are absolute and correct

3. **MCP server doesn't start**
   - Check the mcp-proxy directory exists and contains the code
   - Verify Python dependencies are installed: `cd mcp-proxy && uv sync`
   - Test the server manually: `cd mcp-proxy && uv run homeassistant_mcp`

4. **Claude doesn't recognize devices**
   - Ensure your Home Assistant devices are properly configured
   - Check that areas and device names match what you expect
   - Use the command "get live context" to see available devices

### Debugging

- Check Claude Code logs for MCP server connection issues
- Test the MCP server independently before integrating with Claude
- Verify Home Assistant API access using curl:
  ```bash
  curl -H "Authorization: Bearer YOUR_TOKEN" \
       -H "Content-Type: application/json" \
       http://your-ha-ip:8123/api/states
  ```

## Project Structure

```
homeassistant-mcp-project/
├── README.md                 # This file
├── package.json             # Node.js dependencies
├── package-lock.json        # Dependency lock file
├── run-mcp-proxy.sh         # Convenience script to run MCP server
├── .gitignore              # Git ignore patterns
└── mcp-proxy/              # Home Assistant MCP server (external repo)
    ├── src/                # Python MCP server code
    ├── config.json         # Home Assistant connection config
    └── pyproject.toml      # Python project configuration
```

## Credits

- **Home Assistant MCP Server**: [jloucks/homeassistant-mcp](https://github.com/jloucks/homeassistant-mcp)
- **Model Context Protocol**: [Anthropic MCP](https://github.com/anthropics/mcp)

## License

This project configuration is provided as-is. Please refer to individual component licenses for specific terms.