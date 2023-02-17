import SwiftUI

struct FoodDetailsView: View {
    let food: FoodModel
    
    var body: some View {
        FoodGroceryListView(foodName: food.name)
    }
}

struct FoodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailsView(food: FoodModel(id: UUID(), name: "Tomato"))
    }
}
