//
//  StepperViewModel.swift
//  MagicCarpet
//
//  Created by Yizheng Cai on 10/13/24.
//

import SwiftUI
import HorizonCalendar

class StepperViewModel: ObservableObject {
    // MARK: - Step 1: Search
    @Published var searchQuery: String = ""
    @Published var destinations: [Destination] = MockData.destination
    
    var filteredDestinations: [Destination] {
        if searchQuery.isEmpty {
            return destinations
        } else {
            return destinations.filter { $0.city.lowercased().contains(searchQuery.lowercased()) }
        }
    }
    
    // MARK: - Step 2: Date Selection
    @Published var tripStartDate = Date()
    @Published var tripEndDate = Date().addingTimeInterval(86400 * 7) // Default to 7 days trip
    
    // MARK: - Step 3: Who’s Coming
    @Published var selectedGroup: String? = nil
    @Published var travelingWithChildren = false
    let adult_group = ["Going solo", "Partner"]
    let kids_group = ["Friends", "Family"]
    
    // MARK: - Step 4: How to spend time
    @Published var howTo: [String] = MockData.howTo
    @Published var userInput: String = ""
    @Published var selectedItems: Set<String> = []
    
    // MARK: Visual constants
    var bigButtonWidth: CGFloat? = 120
    var bigButtonHeight: CGFloat? = 90
    var bigButtonCornerRadius: CGFloat = 10
    var selectableTextHeight: CGFloat? = 40
    var selectableTextCornerRadius: CGFloat = 20
    var unselectOpacity: Double = 0.2
    var selectedOpacity: Double = 1
    var selectedBorder: CGFloat = 2
    var unselectBorder: CGFloat = 1
    var textInputBorder: CGFloat = 1
    var textInputBorderColor: Color = Color.gray
    var textInputCornerRadius: CGFloat = 10
    
    // Toggle selection of a text item
    func toggleSelection(of item: String) {
        if selectedItems.contains(item) {
            selectedItems.remove(item)
        } else {
            selectedItems.insert(item)
        }
    }
    
    // Check if an item is selected
    func isSelected(item: String) -> Bool {
        return selectedItems.contains(item)
    }    
}
