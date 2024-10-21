// Created by Bryan Keller on 6/18/20.
// Copyright © 2020 Airbnb Inc. All rights reserved.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import HorizonCalendar
import UIKit
import SwiftUI

// Wrapper for the UIKit ViewController
struct UIKitDateRangeSelectionViewControllerWrapper: UIViewControllerRepresentable {
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    
    // Define the type of ViewController being represented
    typealias UIViewControllerType = DayRangeSelectionViewController

    // Creates the UIViewController instance when the SwiftUI view appears
    func makeUIViewController(context: Context) -> DayRangeSelectionViewController {
        let viewController = 
        if let startDate = startDate, let endDate = endDate {
            DayRangeSelectionViewController(monthsLayout: MonthsLayout.vertical, tempStartDate: startDate)
        } else {
            DayRangeSelectionViewController(monthsLayout: MonthsLayout.vertical)
        }
        
        viewController.updateHandler = { updatedDayRange in
            if let updatedDayRange = updatedDayRange {
                startDate = createDate(month: updatedDayRange.lowerBound.month.month, day: updatedDayRange.lowerBound.day)
                endDate = createDate(month: updatedDayRange.upperBound.month.month, day: updatedDayRange.upperBound.day)
            }
        }
        
        return viewController
        // Return the UIKit view controller
    }

    // Updates the UIViewController when the SwiftUI state changes
    func updateUIViewController(_ uiViewController: DayRangeSelectionViewController, context: Context) {
        // You can update the UIKit view controller here if needed
    }
    
    // Function to create a Date from month and day, defaulting to the current year
    func createDate(month: Int, day: Int, year: Int = Calendar.current.component(.year, from: Date())) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.year = year    // Use the current year or a specified year
        dateComponents.month = month  // Provided month
        dateComponents.day = day      // Provided day
        
        // Create the Date from the components
        return Calendar.current.date(from: dateComponents)
    }
}


final class DayRangeSelectionViewController: BaseViewController {

    var updateHandler: ((DayComponentsRange?) -> Void)?
    
    init(monthsLayout: MonthsLayout, tempStartDate: Date) {
        self.tempStartDate = tempStartDate
        self.tempEndDate = tempStartDate.addingTimeInterval(86400 * 365)
        super.init(monthsLayout: monthsLayout)
    }
    
    required init(monthsLayout: MonthsLayout) {
        self.tempStartDate = Date()
        self.tempEndDate = Date()
        super.init(monthsLayout: monthsLayout)
    }
    
    required init?(coder _: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    // MARK: Internal

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Day Range Selection"
        
        calendarView.daySelectionHandler = { [weak self] day in
            guard let self else { return }
            
            DayRangeSelectionHelper.updateDayRange(
                afterTapSelectionOf: day,
                existingDayRange: &selectedDayRange)
            
            updateHandler?(selectedDayRange)
            
            calendarView.setContent(makeContent())
        }
        
        calendarView.multiDaySelectionDragHandler = { [weak self, calendar] day, state in
            guard let self else { return }
            
            DayRangeSelectionHelper.updateDayRange(
                afterDragSelectionOf: day,
                existingDayRange: &selectedDayRange,
                initialDayRange: &selectedDayRangeAtStartOfDrag,
                state: state,
                calendar: calendar)
            
            calendarView.setContent(makeContent())
        }
    }

    override func makeContent() -> CalendarViewContent {
        let startDate = tempStartDate
        let endDate = tempEndDate

        let dateRanges: Set<ClosedRange<Date>>
        let selectedDayRange = selectedDayRange
        if
          let selectedDayRange,
          let lowerBound = calendar.date(from: selectedDayRange.lowerBound.components),
          let upperBound = calendar.date(from: selectedDayRange.upperBound.components)
        {
            dateRanges = [lowerBound...upperBound]
        } else {
            dateRanges = []
        }

        return CalendarViewContent(
          calendar: calendar,
          visibleDateRange: startDate...endDate,
          monthsLayout: monthsLayout)

          .interMonthSpacing(24)
          .verticalDayMargin(8)
          .horizontalDayMargin(8)

          .dayItemProvider { [calendar, dayDateFormatter] day in
              var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive

            let isSelectedStyle: Bool
            if let selectedDayRange {
              isSelectedStyle = day == selectedDayRange.lowerBound || day == selectedDayRange.upperBound
            } else {
              isSelectedStyle = false
            }

            if isSelectedStyle {
              invariantViewProperties.backgroundShapeDrawingConfig.fillColor = .systemBackground
              invariantViewProperties.backgroundShapeDrawingConfig.borderColor = UIColor(.accentColor)
            }

            let date = calendar.date(from: day.components)

            return DayView.calendarItemModel(
              invariantViewProperties: invariantViewProperties,
              content: .init(
                dayText: "\(day.day)",
                accessibilityLabel: date.map { dayDateFormatter.string(from: $0) },
                accessibilityHint: nil))
          }

          .dayRangeItemProvider(for: dateRanges) { dayRangeLayoutContext in
            DayRangeIndicatorView.calendarItemModel(
              invariantViewProperties: .init(),
              content: .init(
                framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame }))
          }
    }

    // MARK: Private

    private var selectedDayRange: DayComponentsRange?
    private var selectedDayRangeAtStartOfDrag: DayComponentsRange?
    private var tempStartDate: Date
    private var tempEndDate: Date
    
    
}
