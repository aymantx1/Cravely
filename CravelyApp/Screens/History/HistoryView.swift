//
//  HistoryView.swift
//  CravelyApp
//
//  Created by ayman moh on 23/07/2026.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    
    // 1. Declare @Query without setting the predicate inline
    @Query private var todaysTaps: [Tap]
    
    // 2. Compute startOfDay outside the macro in init()
    init() {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        
        _todaysTaps = Query(
            filter: #Predicate<Tap> { tap in
                tap.time >= startOfDay
            },
            sort: \Tap.time,
            order: .reverse
        )
    }

    private var hasCravesToday: Bool {
        !todaysTaps.isEmpty
    }
    
    private var totalMoneySavedToday: Double {
        todaysTaps.reduce(0.0) { $0 + $1.price }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
                .padding(.horizontal, 16)
                .padding(.top, 16)
            
            if hasCravesToday {
                ScrollView(.vertical, showsIndicators: true) {
                    historyListView
                        .padding(.horizontal, 16)
                        .padding(.top, 12)
                }
            } else {
                emptyHistoryView
            }
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Header
    
    private var headerView: some View {
        HStack {
            Text("Cravely")
                .font(.system(size: 28))
                .fontWeight(.heavy)
                .foregroundStyle(.white)
            
            Text("History")
                .font(.system(size: 28))
                .bold()
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 10)
    }
    
    // MARK: - Empty State
    
    private var emptyHistoryView: some View {
        VStack(alignment: .center, spacing: 15) {
            Spacer()
            
            Image(systemName: "clipboard")
                .font(.system(size: 48))
                .foregroundStyle(.white.opacity(0.3))
            
            Text("No Cravings Today")
                .fontWeight(.bold)
                .font(.system(size: 17))
                .foregroundStyle(.white)
            
            Text("Tap \"I Crave One\" on the home screen when you feel the urge")
                .font(.system(size: 13))
                .foregroundStyle(.white.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Spacer()
        }
    }
    
    // MARK: - History List View
    
    private var historyListView: some View {
        LazyVStack(spacing: 16) {
            // Stats summary row
            HStack(spacing: 12) {
                summaryCard(
                    value: "\(todaysTaps.count)",
                    label: "Resisted Today"
                )
                
                summaryCard(
                    value: String(format: "$%.2f", totalMoneySavedToday),
                    label: "Saved Today"
                )
            }
            
            // Date Header
            HStack {
                Text(Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                    .font(.system(size: 14))
                    .foregroundStyle(.white.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.top, 8)
            
            // Log items
            ForEach(todaysTaps) { tap in
                historyRow(for: tap)
            }
        }
    }
    
    // MARK: - Subviews & Helpers
    
    private func summaryCard(value: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.system(size: 26))
                .foregroundStyle(.green)
                .bold()
            
            Text(label)
                .font(.system(size: 13))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 17/255, green: 17/255, blue: 17/255))
        )
    }
    
    private func historyRow(for tap: Tap) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(.green)
                .frame(width: 8, height: 8)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(tap.time.formatted(date: .omitted, time: .shortened))
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                Text(tap.brand)
                    .font(.system(size: 13))
                    .foregroundStyle(.white.opacity(0.5))
            }
            
            Spacer()
            
            Text(String(format: "$%.2f", tap.price))
                .font(.system(size: 16))
                .foregroundStyle(.green)
                .fontWeight(.semibold)
        }
        .padding(.horizontal, 16)
        .frame(height: 64)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 17/255, green: 17/255, blue: 17/255))
        )
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                deleteTap(tap)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    private func deleteTap(_ tap: Tap) {
        modelContext.delete(tap)
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete tap: \(error)")
        }
    }
}

// MARK: - Preview

#Preview {
    HistoryView()
}
