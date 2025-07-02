# ChatGPT iOS App

A native iOS app that provides a ChatGPT-like experience using the OpenAI API. Built with SwiftUI and following modern iOS design patterns.

## Screenshots

The app features:
- **Setup Screen**: Enter your OpenAI API key securely
- **Chat Interface**: Clean message bubbles with typing indicators
- **Navigation**: Easy access to clear chat functionality

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- OpenAI API Key

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd ChatGPTApp
   ```

2. **Open in Xcode**
   ```bash
   open ChatGPTApp.xcodeproj
   ```

3. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

## Setup

1. **Get an OpenAI API Key**
   - Visit [OpenAI Platform](https://platform.openai.com/api-keys)
   - Create a new API key
   - Copy the key (starts with `sk-`)

2. **Configure the App**
   - Launch the app
   - Enter your API key in the setup screen
   - Tap "Start Chat" to begin

## Usage

### Starting a Conversation
1. Launch the app
2. Enter your OpenAI API key if not already set
3. Tap "Start Chat"
4. Type your message and tap the send button or press return

### Features
- **Send Messages**: Type in the text field and send
- **View Responses**: AI responses appear in gray bubbles
- **Clear Chat**: Tap "Clear" in the navigation bar to reset
- **Error Handling**: Invalid API keys or network issues show helpful error messages

## Architecture

The app follows MVVM (Model-View-ViewModel) architecture:

### Models
- `Message.swift`: Data models for chat messages and API requests/responses

### Views
- `ContentView.swift`: Main app coordinator and API key setup
- `ChatView.swift`: Main chat interface
- `MessageView.swift`: Individual message display component

### ViewModels
- `ChatViewModel.swift`: Manages chat state and API interactions

### Services
- `APIService.swift`: Handles OpenAI API communication

## API Configuration

The app uses the OpenAI Chat Completions API with the following settings:
- **Model**: `gpt-3.5-turbo`
- **Temperature**: 0.7
- **Max Tokens**: 1000

## Security

- API keys are stored locally on the device
- No data is transmitted to third parties
- All communication is encrypted via HTTPS

## Customization

### Changing the AI Model
Edit `APIService.swift`:
```swift
let request = ChatRequest(
    model: "gpt-4", // Change to your preferred model
    messages: messages,
    temperature: 0.7,
    maxTokens: 1000
)
```

### Adjusting Response Parameters
Modify the temperature and max tokens in `APIService.swift`:
```swift
temperature: 0.5, // Lower for more focused responses
maxTokens: 2000   // Higher for longer responses
```

