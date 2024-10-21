//
//  DateSelectionView.swift
//  MagicCarpet
//
//  Created by Yizheng Cai on 10/13/24.
//

import SwiftUI
import HorizonCalendar

struct DateSelectionView: View {
    @ObservedObject var viewModel: StepperViewModel
    @State private var showingDatePicker = false
    @State private var tempStartDate: Date?
    @State private var tempEndDate: Date?
    
    var body: some View {
        VStack {
            Text("When do you want to go?")
                .font(.headline)
            
            VStack {
                // The button to open the full sheet
                Button("\(viewModel.tripStartDate, style: .date) ➔ \(viewModel.tripEndDate, style: .date)") {
                    tempStartDate = viewModel.tripStartDate
                    tempEndDate = viewModel.tripEndDate
                    showingDatePicker = true
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showingDatePicker) {
            FullDatePickerSheet(
                viewModel: viewModel,
                showingDatePicker: $showingDatePicker,
                tempStartDate: $tempStartDate,
                tempEndDate: $tempEndDate
            )
        }
    }
}

struct FullDatePickerSheet: View {
    @ObservedObject var viewModel: StepperViewModel
    @Binding var showingDatePicker: Bool
    @Binding var tempStartDate: Date?
    @Binding var tempEndDate: Date?

    var body: some View {
        VStack {
            // Header with "Add dates" title and close button
            HStack {
                Spacer()
                
                Text("Add dates")
                    .font(.headline)
                
                Spacer()
                
                // Close button (x)
                Button(action: {
                    showingDatePicker = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .padding()
                }
            }
            .padding()
            
            // The DatePicker section (two months displayed)
            UIKitDateRangeSelectionViewControllerWrapper(
                startDate: $tempStartDate,
                endDate: $tempEndDate)
            Spacer()
            
            // Footer with Reset and Apply buttons
            VStack {
                Divider() // Separator line
                
                HStack {
                    // Reset button (resets the dates)
                    Button(action: {
                        tempStartDate = Date()
                        tempEndDate = Date().addingTimeInterval(86400 * 7) // Reset to default
                    }) {
                        Text("Reset")
                            .underline()
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    // Apply button (applies the dates and closes the sheet)
                    Button(action: {
                        if let tempStartDate = tempStartDate, let tempEndDate = tempEndDate {
                            viewModel.tripStartDate = tempStartDate
                            viewModel.tripEndDate = tempEndDate
                        }
                        showingDatePicker = false
                    }) {
                        Text("Apply")
                            .bold()
                            .frame(maxWidth: 100, maxHeight: 40)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
            }
        }
        .background(Color.white)
        .ignoresSafeArea()
    }
}

struct DatePickerView: View {
    @Binding var tempStartDate: Date
    @Binding var tempEndDate: Date

    var body: some View {
        VStack {
            // Graphical DatePickers for start and end date selection
            VStack {
                DatePicker("Start Date", selection: $tempStartDate, displayedComponents: [.date])
                    .datePickerStyle(GraphicalDatePickerStyle())
                    .frame(maxWidth: .infinity, maxHeight: 250)
            }
            .padding(.horizontal)
        }
    }
}
