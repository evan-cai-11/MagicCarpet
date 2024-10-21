//
//  WhoIsComingView.swift
//  MagicCarpet
//
//  Created by Yizheng Cai on 10/13/24.
//

import SwiftUI

struct WhoIsComingView: View {
    @ObservedObject var viewModel: StepperViewModel

    
    var body: some View {
        VStack {
            Text("Who's coming with you?")
                .font(.headline)
            
            VStack {
                HStack {
                    ForEach(viewModel.adult_group, id: \.self) { group in
                        Button(action: {
                            viewModel.selectedGroup = group
                            viewModel.travelingWithChildren = false
                        }) {
                            selectionText(text: group)
                        }
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    ForEach(viewModel.kids_group, id: \.self) { group in
                        Button(action: {
                            viewModel.selectedGroup = group
                        }) {
                            selectionText(text: group)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            if viewModel.selectedGroup == "Friends" || viewModel.selectedGroup == "Family" {
                
                Text("Are you traveling with children?")
                    .font(.subheadline)
                    .padding(.top)
                
                HStack {
                    Button(action: {
                        viewModel.travelingWithChildren = true
                    }) {
                        pillText(text: "Yes")
                    }
                    Button(action: {
                        viewModel.travelingWithChildren = false
                    }) {
                        pillText(text: "No")
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
    }
    
    func pillText(text: String) -> some View {
        return Text(text)
                .padding()
                .frame(width: viewModel.bigButtonWidth, height: viewModel.selectableTextHeight)
                .foregroundColor(.gray)
                .overlay(  // Add a border using RoundedRectangle
                    RoundedRectangle(cornerRadius: viewModel.selectableTextCornerRadius)
                        .stroke(Color.gray.opacity(viewModel.travelingWithChildren && text == "Yes" || !viewModel.travelingWithChildren && text == "No" ? viewModel.selectedOpacity : viewModel.unselectOpacity), lineWidth: viewModel.travelingWithChildren && text == "Yes" || !viewModel.travelingWithChildren && text == "No" ? viewModel.selectedBorder : viewModel.unselectBorder) // Set the border color and line thickness (pounds)
                )
                .padding()
    }
    
    func selectionText(text: String) -> some View {
        return Text(text)
                .padding()
                .frame(width: viewModel.bigButtonWidth, height: viewModel.bigButtonHeight)
                .foregroundColor(.gray)
                .overlay(  // Add a border using RoundedRectangle
                    RoundedRectangle(cornerRadius: viewModel.bigButtonCornerRadius)
                        .stroke(Color.gray.opacity(viewModel.selectedGroup == text ? viewModel.selectedOpacity : viewModel.unselectOpacity), lineWidth: viewModel.selectedGroup == text ? viewModel.selectedBorder : viewModel.unselectBorder) // Set the border color and line thickness (pounds)
                )
                .padding()
    }
}

