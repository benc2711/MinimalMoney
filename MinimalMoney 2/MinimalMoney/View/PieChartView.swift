import SwiftUI
import Charts

@available(iOS 17.0, *)
struct PieChartView: View {
    @ObservedObject var viewModel: PurchaseViewModel
    let days: Int
    @State private var selectedCount: Int?
    @State private var selectedSector: String?

   

    var body: some View {
        VStack {
            Chart {
                ForEach(Array(viewModel.spendingByCategory(for: days).keys), id: \.self) { category in
                    let total = viewModel.spendingByCategory(for: days)[category] ?? 0
                    SectorMark(
                        angle: .value(category, total),
                        innerRadius: .ratio(0.65),
                        angularInset: 2.0
                    )
                    .foregroundStyle(by: .value("Category", category))
                    .cornerRadius(10)
                    .annotation(position: .overlay){
                        Text("\(total, specifier: "%.2f")")
                            .font(.system(size: 6))
                            .foregroundStyle(Color.white)
                    }
                    .opacity(selectedSector == nil ? 1.0 : (selectedSector == category ? 1.0 : 0.5))
                }
            }
            .chartAngleSelection(value: $selectedCount)
            .onChange(of: selectedCount) { newValue in
                selectedSector = findSelectedSector(value: newValue)
                viewModel.selectedCatagory = selectedSector ?? ""
                print("Selected Sector Updated: \(viewModel.selectedCatagory)")
            }
        }
    }



    private func findSelectedSector(value: Int?) -> String? {
        guard let value = value else { return nil }
        
        var accumulatedValue = 0
        let spendingByCategory = viewModel.spendingByCategory(for: days)
        for category in spendingByCategory.keys {
            if let total = spendingByCategory[category] {
                accumulatedValue += Int(total)
                if value <= accumulatedValue {
                    return category
                }
            }
        }
        return ""
    }

    func transactionsForCategory(_ category: String) -> [Transaction] {
        viewModel.purchases.filter { $0.category == category }
    }
}
