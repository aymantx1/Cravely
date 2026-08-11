//
//  HistoryView.swift
//  CravelyApp
//
//  Created by ayman moh on 23/07/2026.
//
import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(AppModel.self) private var appModel
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

        private var craves: Bool {
            !todaysTaps.isEmpty
        }
            
        private var totalMoneySavedToday: Double {
            todaysTaps.reduce(0) { $0 + $1.price }
        }
    
    var body: some View {
        VStack {
            headerView
            
            if craves {
                ScrollView(.vertical, showsIndicators: true) {
                    HistoryListView
                        .padding(.horizontal)
                }
            } else {
                EmptyHistoryView
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var headerView: some View {
        HStack {
            Text("Cravely")
                .font(.system(size: 28))
                .fontWeight(.heavy)
            
            Text("History")
                .font(.system(size: 28))
                .bold()
                .opacity(0.5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 30)
    }
    
    private var EmptyHistoryView: some View {
        VStack(alignment: .center, spacing: 15) {
            Spacer()
            
            HStack {
                Image("clipBoard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .opacity(0.3)
            }
            HStack {
                Text("No Cravings Today")
                    .fontWeight(.bold)
                    .font(.system(size: 17))
            }
            HStack {
                Text("Tap \"I Crave One\" on the home screen when you feel the urge")
                    .font(.system(size: 12))
                    .opacity(0.5)
            }
            Spacer()
        }
    }
    
    private var HistoryListView: some View {
        LazyVStack(spacing: 12) {
            HStack {
                ZStack {
                    Rectangle()
                        .fill(Color(red: 17/255, green: 17/255, blue: 17/255))
                        .frame(width: 170, height: 100)
                        .cornerRadius(14)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(todaysTaps.count)")
                            .font(.system(size: 28))
                            .foregroundStyle(.green)
                            .bold()
                        Text("Resisted Today")
                            .font(.system(size: 14))
                            .opacity(0.5)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
                
                ZStack {
                    Rectangle()
                        .fill(Color(red: 17/255, green: 17/255, blue: 17/255))
                        .frame(width: 170, height: 100)
                        .cornerRadius(14)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("$\(totalMoneySavedToday, specifier: "%.2f")")
                            .font(.system(size: 28))
                            .foregroundStyle(.green)
                            .bold()
                        Text("Saved today")
                            .font(.system(size: 14))
                            .opacity(0.5)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
            }
            
            HStack {
                Text(Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                    .font(.system(size: 14))
                    .opacity(0.5)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            ForEach(todaysTaps) { tap in
                HStack(spacing: 12) {
                    Rectangle()
                        .fill(.green)
                        .frame(width: 8, height: 8)
                        .cornerRadius(4)
                    
                    VStack(alignment: .leading) {
                        Text(tap.time.formatted(date: .omitted, time: .shortened))
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                        Text(tap.brand.rawValue)
                            .font(.system(size: 14))
                            .opacity(0.5)
                    }
                    
                    Spacer()
                    
                    Text("$\(tap.price, specifier: "%.2f")")
                        .font(.system(size: 16))
                        .foregroundStyle(.green)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 16)
                .frame(height: 70)
                .frame(maxWidth: .infinity)
                .background(
                    Color(red: 17/255, green: 17/255, blue: 17/255)
                        .cornerRadius(14)
                )
            }
        }
    }
}

#Preview {
    HistoryView()
        .environment(AppModel())
}
