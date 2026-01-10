//
//  GoalHistoryCalendar.swift
//  fontes
//
//  Created by Mateus Costa on 26/12/2025.
//

import SwiftUI

// History Calendar Component
struct GoalHistoryCalendar: View {
    let daysInMonth = 30
    // Mocked completed days
    let completedDays: Set<Int> = [2, 3, 5, 8, 9, 10, 14, 16, 20, 21, 22, 25]
    
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("History")
                .font(.title3)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(1...daysInMonth, id: \.self) { day in
                    ZStack {
                        if completedDays.contains(day) {
                            Circle()
                                .fill(Color.pink)
                                .frame(width: 32, height: 32)
                        } else {
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 32, height: 32)
                        }
                        
                        Text("\(day)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(completedDays.contains(day) ? .white : .primary)
                    }
                }
            }
            .padding(20)
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .padding(.horizontal)
        }
    }
}
