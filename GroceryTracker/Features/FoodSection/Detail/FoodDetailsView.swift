import SwiftUI

struct FoodDetailsView: View {
    let model: FoodModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text(model.name)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 2, x: 2, y: 2)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .cornerRadius(20)
    }
}

struct FoodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailsView(model: FoodModel(id: 0, name: "Blueberry"))
    }
}
