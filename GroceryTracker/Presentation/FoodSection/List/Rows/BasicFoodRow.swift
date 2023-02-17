import SwiftUI

struct BasicFoodRow: View {
    var model: FoodModel
    
    var body: some View {
        Text(model.name)
            .padding(10)
    }
}

struct BasicFoodRow_Previews: PreviewProvider {
    static var previews: some View {
        BasicFoodRow(model: FoodModel(id: UUID(), name: "Tomato"))
    }
}
