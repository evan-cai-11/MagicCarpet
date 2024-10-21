//
//  HowToSpendTime.swift
//  MagicCarpet
//
//  Created by Yizheng Cai on 10/20/24.
//

import SwiftUI

struct HowToSpendTimeView: View {
    @ObservedObject var viewModel: StepperViewModel

    var body: some View {
        
        VStack {
            Text("Who's coming with you?")
                .font(.headline)
            
            Text("Choose as many as you'd like")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.6))
            
            GeometryReader { geometry in
                let screenWidth = geometry.size.width // Get the screen width
                let textItems = viewModel.howTo
                // Use a VStack to hold multiple HStacks to simulate wrapping behavior
                WrapView(viewModel: viewModel, items: textItems, screenWidth: screenWidth)
            }
            .padding()
            
            Text("Other(optional)")
                .font(.subheadline)
                .bold()
            
            TextField("Seperate each entry with a comma", text: $viewModel.userInput)
                .padding()
                .overlay(  // Add a border using RoundedRectangle
                    RoundedRectangle(cornerRadius: viewModel.textInputCornerRadius)
                        .stroke(viewModel.textInputBorderColor, lineWidth: viewModel.textInputBorder)
                    )
                .padding(.horizontal)
        }
    }
}

// Helper view to wrap text items
struct WrapView: View {
    @ObservedObject var viewModel: StepperViewModel
    
    let items: [String]
    let screenWidth: CGFloat
    
    var body: some View {
        // Calculate rows of wrapped text items
        let wrappedRows = calculateWrappedRows(items: items, screenWidth: screenWidth)
        
        // Create a VStack for each row (HStack)
        VStack(alignment: .leading, spacing: 10) {
            ForEach(wrappedRows, id: \.self) { rowItems in
                HStack {
                    ForEach(rowItems, id: \.self) { item in
                        Text(item)
                            .padding()
                            .frame(height: viewModel.selectableTextHeight)
                            .overlay(  // Add a border using RoundedRectangle
                                RoundedRectangle(cornerRadius: viewModel.selectableTextCornerRadius)
                                    .stroke(Color.gray.opacity(viewModel.isSelected(item: item) ? viewModel.selectedOpacity : viewModel.unselectOpacity), lineWidth: viewModel.isSelected(item: item) ? viewModel.selectedBorder : viewModel.unselectBorder) // Set the border color and line thickness (pounds)
                                )
                            .onTapGesture {
                                viewModel.toggleSelection(of: item) // Toggle selection on tap
                            }
                    }
                }
            }
        }
    }
    
    // Helper function to calculate the wrapped rows based on screen width
    private func calculateWrappedRows(items: [String], screenWidth: CGFloat) -> [[String]] {
        var rows: [[String]] = []
        var currentRow: [String] = []
        var currentRowWidth: CGFloat = 0
        
        for item in items {
            let itemWidth = textWidth(for: item)
            
            // Check if adding the next item exceeds the available screen width
            if currentRowWidth + itemWidth > screenWidth {
                rows.append(currentRow) // Save the current row
                currentRow = [item]     // Start a new row with the current item
                currentRowWidth = itemWidth // Reset the row width
            } else {
                currentRow.append(item) // Add item to the current row
                currentRowWidth += itemWidth // Update the current row width
            }
        }
        
        // Add the last row if there are remaining items
        if !currentRow.isEmpty {
            rows.append(currentRow)
        }
        
        return rows
    }
    
    // Helper function to estimate text width based on the string
    private func textWidth(for text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 17)
        let attributes = [NSAttributedString.Key.font: font]
        let size = (text as NSString).size(withAttributes: attributes)
        return size.width + 20 // Add padding for better fit
    }
}
