//
//  QuestionareStepperView.swift
//  MagicCarpet
//
//  Created by Yizheng Cai on 10/13/24.
//

import SwiftUI

struct QuestionareStepperView: View {
    @ObservedObject var viewModel: StepperViewModel
    @State private var currentStep = 0
    let totalSteps = 4
    
    var body: some View {
        VStack {
            // Header with Back Arrow, Progress Bar, and Exit Button
            HStack {
                Button(action: {
                    if currentStep > 0 {
                        currentStep -= 1
                    }
                }) {
                    Image(systemName: "arrow.left")
                        .padding()
                }
                
                Spacer()
                
                Button(action: {
                    // Exit the stepper (handle as needed)
                }) {
                    Image(systemName: "xmark")
                        .padding()
                }
            }
            
            // Progress Bar
            ProgressView(value: Double(currentStep), total: Double(totalSteps - 1))
                .progressViewStyle(LinearProgressViewStyle(tint: Color.blue))
                .padding(.horizontal)
                .padding(.bottom)
            
            // Content for each step
            Group {
                if currentStep == 0 {
                    DestinationSearchView(viewModel: viewModel)
                } else if currentStep == 1 {
                    DateSelectionView(viewModel: viewModel)
                } else if currentStep == 2 {
                    WhoIsComingView(viewModel: viewModel)
                } else if currentStep == 3 {
                    HowToSpendTimeView(viewModel: viewModel)
                }
            }
            
            Spacer()
            
            // Footer with Next Button
            Button(action: {
                if currentStep < totalSteps - 1 {
                    currentStep += 1
                } else {
                    // Handle final submission if needed
                }
            }) {
                Text(currentStep == totalSteps - 1 ? "Submit" : "Next")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
        .padding(.vertical)
    }
}

