//
//  DestinationView.swift
//  MagicCarpet
//
//  Created by Yizheng Cai on 10/13/24.
//

import SwiftUI

struct DestinationSearchView: View {
    @ObservedObject var viewModel: StepperViewModel
    @State private var selectedDestination: Destination? = nil
    
    var body: some View {
        VStack {
            Text("Where do you want to go?")
                .font(.headline)
            
            TextField("City/Town", text: $viewModel.searchQuery)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            
            NavigationView {
                List(viewModel.filteredDestinations, id: \.id) { destination in
                    DestinationCell(destination: destination)
                }
            }
            
            Spacer()
        }
    }
}


