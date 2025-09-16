import SwiftUI

struct SearchBar: View{
    @Binding var text: String
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            TextField("Enter city name", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: onSearch){
                Image(systemName: "magnifyingglass")
            }
            
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
