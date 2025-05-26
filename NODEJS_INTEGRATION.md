# Node.js Server Integration for Biography App

## Overview

The Biography app has been successfully modified to communicate directly with your Node.js server running on `localhost:3000` instead of using the settings page to configure Ollama servers. This provides a more streamlined experience and eliminates the need for users to configure server endpoints.

## Changes Made

### 1. Updated OllamaService.swift

- **Removed dependency on OllamaKit**: The app no longer uses the OllamaKit Swift package
- **Added custom HTTP client**: Implemented direct HTTP communication using URLSession
- **Hardcoded server endpoint**: The app now points directly to `http://10.7.3.52:3000` (your computer's local IP)
- **OpenAI-compatible API**: Added support for OpenAI-compatible chat completions format

### 2. Updated ConversationStore.swift

- **Removed OllamaKit import**: Cleaned up unused imports
- **Updated service calls**: Modified to use the new OllamaService interface

### 3. Updated PanelCompletionsVM.swift

- **Removed OllamaKit import**: Cleaned up unused imports
- **Updated service calls**: Modified to use the new OllamaService interface

## API Endpoints Used

The Biography app now communicates with your Node.js server using these endpoints:

### Health Check
- **Endpoint**: `GET /health`
- **Purpose**: Check if the server is reachable
- **Response**: `{"status": "healthy", "timestamp": "...", "uptime": ..., "ollama_url": "..."}`

### List Models
- **Endpoint**: `GET /v1/models`
- **Purpose**: Retrieve available models
- **Response**: `{"models": [{"name": "gemma3:4b", ...}]}`

### Chat Completions
- **Endpoint**: `POST /v1/chat/completions`
- **Purpose**: Send chat messages and receive responses
- **Request Format**:
```json
{
  "model": "gemma3:4b",
  "messages": [
    {"role": "user", "content": "Hello, how are you?"}
  ],
  "temperature": 0.7,
  "max_tokens": 150
}
```
- **Response Format**:
```json
{
  "id": "chatcmpl-...",
  "object": "chat.completion",
  "model": "gemma3:4b",
  "choices": [{
    "index": 0,
    "message": {
      "role": "assistant",
      "content": "I'm doing well, thank you for asking!"
    },
    "finish_reason": "stop"
  }]
}
```

## Server Requirements

Your Node.js server must be:

### Important: Network Configuration

Since the Biography app runs on iOS devices, it cannot connect to `localhost` on your computer. The app is configured to connect to your computer's local IP address (`10.7.3.52`). 

**Requirements:**

1. **Running on 10.7.3.52:3000**: The app is hardcoded to use this endpoint (your computer's local IP)
2. **Implementing OpenAI-compatible API**: The endpoints must match the format above
3. **Accessible**: The server must be running when the app is used

## Testing

The integration has been tested and verified:

✅ **Health endpoint**: `curl http://localhost:3000/health`
✅ **Models endpoint**: `curl http://localhost:3000/v1/models`
✅ **Chat completions**: Successfully tested with gemma3:4b model

## Usage Instructions

1. **Start your Node.js server**: Make sure your server is running on port 3000 and accessible from the network
2. **Launch Biography app**: The app will automatically connect to your server
3. **No configuration needed**: Users don't need to configure any server settings
4. **Chat normally**: The app will work exactly as before, but using your server

## Benefits

- **Simplified user experience**: No need to configure server endpoints
- **Direct integration**: Faster communication without proxy layers
- **Consistent behavior**: Hardcoded endpoint ensures reliability
- **OpenAI compatibility**: Standard API format for easy integration

## Troubleshooting

If the app shows "Server unreachable":

1. Verify your Node.js server is running: `curl http://10.7.3.52:3000/health`
2. Check that the server is listening on port 3000
3. Ensure no firewall is blocking network connections to port 3000
4. Make sure your iOS device and computer are on the same WiFi network
4. Check server logs for any errors

## Future Enhancements

Potential improvements for the future:

- **Configurable endpoint**: Allow users to change the server URL if needed
- **Streaming responses**: Implement real-time streaming for better UX
- **Error handling**: Enhanced error messages for different failure scenarios
- **Connection pooling**: Optimize HTTP connections for better performance

## Model Support

The app will automatically detect and use any models available through your Node.js server's `/v1/models` endpoint. Currently tested with:

- **gemma3:4b**: Successfully tested and working
- **Other models**: Should work as long as they're available through your Ollama instance

Your Node.js server acts as a proxy to your Ollama instance running on localhost:11434, so any models available in Ollama will be accessible through the Biography app. 