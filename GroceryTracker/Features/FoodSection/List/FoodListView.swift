import SwiftUI

struct FoodListView: View {
    var searchText: String
    
    var data: [FoodModel] = [
        FoodModel(id: 0, name: "Tomato"),
        FoodModel(id: 1, name: "Lettuce"),
        FoodModel(id: 2, name: "Potato")
    ]
    
    var body: some View {
        List(getData()) { foodModel in
            NavigationLink(destination: FoodDetailsView(food: foodModel)) {
                BasicFoodRow(model: foodModel)
            }
        }
        .navigationBarHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
        
    private func getData() -> [FoodModel] {
        if searchText.isEmpty {
            return data
        } else {
            return data.filter { $0.name.lowercased().contains(searchText.lowercased())  }
        }
    }
}

struct FoodListView_Previews: PreviewProvider {
    static var previews: some View {
        FoodListView(searchText: "")
    }
}
