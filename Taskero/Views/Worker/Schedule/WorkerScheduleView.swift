//
//  WorkerScheduleView.swift
//  Taskero
//

import SwiftUI

struct WorkerScheduleView: View {
    let mainColor = Color.brandGreen
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    
    // Calendar Helpers
    private let calendar = Calendar.current
    private let daysInWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    // Filter jobs for selected date
    var jobsForSelectedDate: [WorkerJob] {
        MockData.workerJobs.filter { 
            calendar.isDate($0.date, inSameDayAs: selectedDate) &&
            ($0.status == .accepted || $0.status == .inProgress || $0.status == .completed)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("My Schedule")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
                
                // Calendar Component
                VStack(spacing: 20) {
                    // Month & Year / Navigation
                    HStack {
                        Text(monthYearString(from: currentMonth))
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        HStack(spacing: 20) {
                            Button(action: { changeMonth(by: -1) }) {
                                Image(systemName: "chevron.left")
                                    .font(.title3)
                                    .foregroundColor(.black)
                            }
                            Button(action: { changeMonth(by: 1) }) {
                                Image(systemName: "chevron.right")
                                    .font(.title3)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                    
                    // Days of Week Header
                    HStack {
                        ForEach(daysInWeek, id: \.self) { day in
                            Text(day)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    // Calendar Grid
                    let days = getDaysInMonth()
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 15) {
                        ForEach(days, id: \.self) { date in
                            if let date = date {
                                DayCell(
                                    date: date,
                                    isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                                    hasJob: hasJobOn(date),
                                    mainColor: mainColor
                                )
                                .onTapGesture {
                                    withAnimation { selectedDate = date }
                                }
                            } else {
                                Color.clear
                                    .frame(height: 40)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.04), radius: 10, y: 5)
                .padding(.horizontal)
                
                // Jobs List for Selected Date
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Jobs on \(dateString(from: selectedDate))")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(jobsForSelectedDate.count) jobs")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(mainColor)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.top, 24)
                    
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            if jobsForSelectedDate.isEmpty {
                                VStack(spacing: 12) {
                                    Spacer().frame(height: 40)
                                    Image(systemName: "calendar.badge.clock")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray.opacity(0.3))
                                    Text("Free day! No jobs scheduled.")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            } else {
                                ForEach(jobsForSelectedDate) { job in
                                    NavigationLink(destination: WorkerJobDetailView(job: job)) {
                                        WorkerJobCard(job: job)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
                
                Spacer()
            }
            .background(Color.gray.opacity(0.03).ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Helper Methods
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func dateString(from date: Date) -> String {
        if calendar.isDateInToday(date) { return "Today" }
        if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
    
    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    private func hasJobOn(_ date: Date) -> Bool {
        MockData.workerJobs.contains { 
            calendar.isDate($0.date, inSameDayAs: date) &&
            ($0.status == .accepted || $0.status == .inProgress || $0.status == .completed)
        }
    }
    
    private func getDaysInMonth() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth),
              let monthFirstWeek = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start) else {
            return []
        }
        
        var days: [Date?] = []
        
        // Add empty days before the first day of the month
        let firstDayWeekday = calendar.component(.weekday, from: monthInterval.start)
        for _ in 1..<firstDayWeekday {
            days.append(nil)
        }
        
        // Add actual days
        var currentDate = monthInterval.start
        while currentDate < monthInterval.end {
            days.append(currentDate)
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
            currentDate = nextDate
        }
        
        return days
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let hasJob: Bool
    let mainColor: Color
    
    var isToday: Bool { Calendar.current.isDateInToday(date) }
    
    var body: some View {
        VStack(spacing: 5) {
            Text("\(Calendar.current.component(.day, from: date))")
                .font(.system(size: 16))
                .fontWeight(isSelected ? .bold : (isToday ? .semibold : .regular))
                .foregroundColor(isSelected ? .white : (isToday ? mainColor : .black))
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(isSelected ? mainColor : (isToday ? mainColor.opacity(0.1) : Color.clear))
                )
            
            // Job Indicator Dot
            Circle()
                .fill(hasJob ? mainColor : Color.clear)
                .frame(width: 4, height: 4)
        }
    }
}

#Preview {
    WorkerScheduleView()
}
