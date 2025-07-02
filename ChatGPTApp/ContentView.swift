import SwiftUI

struct ContentView: View {
    @State private var apiKey: String = ""
    @State private var isAPIKeySet: Bool = false
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        Group {
            if isAPIKeySet {
                ChatView(apiKey: apiKey)
            } else {
                setupView
            }
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var setupView: some View {
        NavigationView {
            VStack(spacing: 24) {
                // App Icon and Title
                VStack(spacing: 16) {
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 80))
                        .foregroundColor(.blue)
                    
                    Text("ChatGPT iOS")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Your personal AI assistant")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // API Key Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("OpenAI API Key")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    SecureField("Enter your OpenAI API key", text: $apiKey)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    Text("Your API key is stored locally and never shared.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 20)
                
                // Get API Key Button
                Button("Get API Key") {
                    if let url = URL(string: "https://platform.openai.com/api-keys") {
                        UIApplication.shared.open(url)
                    }
                }
                .foregroundColor(.blue)
                
                Spacer()
                
                // Start Chat Button
                Button(action: validateAndStart) {
                    HStack {
                        Image(systemName: "message.fill")
                        Text("Start Chat")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(apiKey.isEmpty ? Color.gray : Color.blue)
                    )
                }
                .disabled(apiKey.isEmpty)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("Setup")
            .navigationBarHidden(true)
        }
    }
    
    private func validateAndStart() {
        guard !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert("Please enter your OpenAI API key")
            return
        }
        
        // Basic validation - API key should start with "sk-"
        if !apiKey.hasPrefix("sk-") {
            showAlert("Invalid API key format. OpenAI API keys start with 'sk-'")
            return
        }
        
        isAPIKeySet = true
    }
    
    private func showAlert(_ message: String) {
        alertMessage = message
        showingAlert = true
    }
}

#Preview {
    ContentView()
} 