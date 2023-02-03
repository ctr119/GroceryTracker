import SwiftUI

struct FoodGroceryRowView: View {
    let foodName: String
    let model: FoodGroceryModel
    
    var body: some View {
        HStack {
            Text(model.name)
            Spacer()
            Text(model.productPrices[foodName] ?? "---")
        }
        .padding()
    }
}

struct FoodGroceryRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FoodGroceryRowView(foodName: "Tomato",
                           model: FoodGroceryModel(id: 0,
                                               name: "Mercadona",
                                               productPrices: [
                                                "Tomato" : "2.48 €/kg"
                                               ]))
            
            FoodGroceryRowView(foodName: "Potato",
                           model: FoodGroceryModel(id: 0,
                                               name: "Mercadona",
                                               productPrices: [
                                                "Tomato" : "2.48 €/kg"
                                               ]))
        }
    }
}
