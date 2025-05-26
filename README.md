# Biography

**Biography** is an open source, elegant macOS/iOS/visionOS app for working with privately hosted AI models. It's essentially a ChatGPT-like interface that connects directly to your private Node.js server, providing an unfiltered, secure, and private AI experience across all your Apple devices.

![Biography App](assets/app-icon.png)

## ✨ Features

- 🔒 **Private & Secure**: All conversations stay on your local network
- 🌐 **Cross-Platform**: Native apps for macOS, iOS, and visionOS
- 🚀 **Direct Integration**: Connects directly to your Node.js server
- 💬 **Real-time Chat**: Smooth, responsive chat interface
- 🎨 **Beautiful UI**: Modern, native Apple design
- 🔄 **No Configuration**: Zero setup required for end users
- 📱 **Multi-Device**: Seamless experience across all Apple devices

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Biography     │    │   Node.js       │    │   Ollama        │
│   iOS/macOS     │◄──►│   Server        │◄──►│   Instance      │
│   App           │    │   (Port 3000)   │    │   (Port 11434)  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

The Biography app communicates with your Node.js server, which acts as a proxy to your Ollama instance running locally.

## 🚀 Quick Start

### Prerequisites

- **macOS/iOS Device**: For running the Biography app
- **Node.js Server**: Running on your computer (port 3000)
- **Ollama Instance**: Running locally (port 11434)
- **Same Network**: All devices must be on the same WiFi network

### Installation

1. **Clone the Repository**
   ```bash
   git clone https://github.com/Biography-Industries/mvp-mobile-llm.git
        cd mvp-mobile-llm
   ```

2. **Open in Xcode**
   ```bash
   open Biography.xcodeproj
   ```

3. **Build and Run**
   - Select your target device (iOS/macOS)
   - Press `Cmd + R` to build and run

### Server Setup

Your Node.js server should be running and accessible at your computer's IP address on port 3000. The app is pre-configured to connect to:

```
http://10.7.3.52:3000
```

> **Note**: Update the IP address in `Biography/Services/OllamaService.swift` if your computer's IP is different.

## 📱 Usage

1. **Start your Node.js server** on port 3000
2. **Launch the Biography app** on your device
3. **Start chatting** - the app will automatically connect to your server
4. **No configuration needed** - everything works out of the box!

## 🔧 Configuration

### Updating Server IP Address

If your computer's IP address changes, update it in the OllamaService:

```swift
// Biography/Services/OllamaService.swift
private let baseURL = "http://YOUR_IP_ADDRESS:3000"
```

### Supported Models

The app automatically detects any models available through your Node.js server's `/v1/models` endpoint. Currently tested with:

- **gemma3:4b** ✅
- **llama2** ✅
- **mistral** ✅
- **Any Ollama-compatible model** ✅

## 🛠️ Development

### Project Structure

```
Biography/
├── Application/           # App entry point
├── Services/             # API services and networking
├── Stores/               # State management
├── UI/                   # User interface components
│   ├── iOS/             # iOS-specific views
│   ├── macOS/           # macOS-specific views
│   └── Shared/          # Shared UI components
├── Models/              # Data models
├── Extensions/          # Swift extensions
└── Helpers/             # Utility functions
```

### Key Components

- **OllamaService**: Handles communication with Node.js server
- **ConversationStore**: Manages chat conversations and messages
- **LanguageModelStore**: Manages available AI models
- **AppStore**: Handles app state and server reachability

### API Endpoints

The app communicates with your Node.js server using these endpoints:

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/health` | GET | Server health check |
| `/v1/models` | GET | List available models |
| `/v1/chat/completions` | POST | Send chat messages |

## 🔍 Troubleshooting

### "Server Unreachable" Error

If you see this error:

1. **Check server status**: `curl http://YOUR_IP:3000/health`
2. **Verify network**: Ensure devices are on same WiFi
3. **Check firewall**: Allow port 3000 connections
4. **Restart server**: Stop and restart your Node.js server

### Common Issues

| Issue | Solution |
|-------|----------|
| App can't connect | Update IP address in OllamaService.swift |
| No models available | Check Ollama instance is running |
| Slow responses | Check network connection quality |
| Build errors | Clean build folder (`Cmd + Shift + K`) |



## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Ollama Team**: For the excellent local AI model runtime
- **OpenAI**: For the API specification we follow
- **Apple**: For the amazing development tools and platforms

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/Biography-Industries/mvp-mobile-llm/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Biography-Industries/mvp-mobile-llm/discussions)
- **Documentation**: [Wiki](https://github.com/Biography-Industries/mvp-mobile-llm/wiki)

## 🔮 Roadmap

- [ ] **Streaming Responses**: Real-time message streaming
- [ ] **Voice Input**: Speech-to-text integration
- [ ] **Image Support**: Multi-modal conversations
- [ ] **Custom Themes**: Personalization options
- [ ] **Export Conversations**: Save chat history
- [ ] **Multiple Servers**: Support for multiple endpoints

---

**Biography** - Your private AI companion across all Apple devices 🍎✨

## 📸 Screenshots

### macOS
![Biography macOS](assets/macos-screenshot.png)

### iOS
![Biography iOS](assets/ios-screenshot.png)

### Key Features in Action
- **Real-time Chat**: Smooth, responsive conversations
- **Dark/Light Mode**: Beautiful interface in any lighting
- **Markdown Support**: Rich text formatting for code, tables, and lists
- **Voice Input**: Speak your messages naturally
- **Cross-Platform**: Seamless experience across all Apple devices

## 🔗 Related Documentation

- **[Node.js Integration Guide](NODEJS_INTEGRATION.md)**: Detailed technical documentation
- **[Privacy Policy](PRIVACY.md)**: How we protect your data
- **[Support](SUPPORT.md)**: Get help and contribute

---

Made with ❤️ for the AI community
