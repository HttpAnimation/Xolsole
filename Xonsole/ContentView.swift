import SwiftUI

struct ContentView: View {
    @State private var command: String = ""
    @State private var output: String = ""

    var body: some View {
        VStack(spacing: 0) {
            Text("Xonole")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding()
                .background(Color.gray.opacity(0.1))

            ScrollView {
                Text(output)
                    .foregroundColor(.black)
                    .padding()
            }

            HStack {
                TextField("Enter command", text: $command)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding()

                Button("Run Command") {
                    runCommand()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                .padding()
            }
        }
    }

    func runCommand() {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/zsh"

        let fileHandle = pipe.fileHandleForReading
        task.launch()

        let data = fileHandle.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            self.output += "\n\(output)"
        }
        task.waitUntilExit()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
