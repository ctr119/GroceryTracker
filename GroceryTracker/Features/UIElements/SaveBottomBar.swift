import SwiftUI

struct SaveBottomBar: View {
    let saveAction: () -> Void
    let cancelAction: () -> Void
    
    var body: some View {
        HStack {
            Button("Cancel") {
                cancelAction()
            }
            .foregroundColor(.red)
            Spacer()
            Button {
                saveAction()
            } label: {
                Text("Save").bold()
            }
        }
        .padding()
    }
}

struct SaveBottomBar_Previews: PreviewProvider {
    static var previews: some View {
        SaveBottomBar {
            // Intentionally empty
        } cancelAction: {
            // Intentionally empty
        }
    }
}
