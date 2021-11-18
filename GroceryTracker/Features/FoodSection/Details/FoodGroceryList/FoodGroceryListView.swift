import SwiftUI

struct FoodGroceryListView: View {
    let foodName: String
    
    static let productPrices = [
        "Tomato" : "2.48 €/kg",
        "Potato" : "1.00 €/kg",
        "Lettuce" : "0.60 €/kg"
    ]
    
    private let groceries: [FoodGroceryModel] = [
        FoodGroceryModel(id: 0, name: "Mercadona", productPrices: FoodGroceryListView.productPrices),
        FoodGroceryModel(id: 1, name: "Lidl", productPrices: FoodGroceryListView.productPrices),
        FoodGroceryModel(id: 2, name: "Aldi", productPrices: FoodGroceryListView.productPrices),
        FoodGroceryModel(id: 3, name: "Coviran", productPrices: FoodGroceryListView.productPrices)
    ]
    
    var body: some View {
        List {
            Section {
                ForEach(groceries) { grocery in
                    FoodGroceryRowView(foodName: foodName, model: grocery)
                }
            } header: {
                Text("Groceries")
            }
        }
        .navigationTitle(foodName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FoodGroceryListView_Previews: PreviewProvider {
    static var previews: some View {
        FoodGroceryListView(foodName: "Tomato")
    }
}
