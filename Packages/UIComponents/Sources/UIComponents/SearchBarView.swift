import SwiftUI

public struct SearchBarView: View {
    @State private var isEditing = false
    
    @Binding var text: String
    
    public init(text: Binding<String>) {
        _text = text
    }
    
    public var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(getSearchIcon())
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing {
                getCancelButton()
            }
        }
    }
    
    private func getSearchIcon() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 8)
            
            if isEditing {
                getClearButton()
            }
        }
    }
    
    private func getClearButton() -> some View {
        Button(action: {
            self.text = ""
        }) {
            Image(systemName: "multiply.circle.fill")
                .foregroundColor(.gray)
                .padding(.trailing, 8)
        }
    }
    
    private func getCancelButton() -> some View {
        Button(action: {
            self.isEditing = false
            self.text = ""
            
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }) {
            Text("Cancel")
                .foregroundColor(Color(.systemBlue))
        }
        .padding(.trailing, 10)
        .transition(.move(edge: .trailing))
    }
}

struct SearchBarView_Previews: PreviewProvider {
    @State private static var text = "Diego"
    
    static var previews: some View {
        SearchBarView(text: SearchBarView_Previews.$text)
    }
}
