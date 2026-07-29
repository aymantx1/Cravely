//
//  HistoryView.swift
//  CravelyApp
//
//  Created by ayman moh on 23/07/2026.
//

import SwiftUI


struct HistoryView: View {
    @State var craves: Bool  = true
    
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
        }    .frame(maxWidth: .infinity, maxHeight: .infinity)
        
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
        VStack(alignment: .center, spacing: 15){
            
            Spacer()
            
            HStack{
                Image("clipBoard")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .opacity(0.3)
            }
            HStack{
                Text("No Cravings yet")
                    .fontWeight(.bold)
                    .font(.system(size: 17))
            }
            HStack{
                Text("Tap \"I Crave One\" on the home screen when you feel the urge")
                    .font(.system(size: 12))
                    .opacity(0.5)
            }
            Spacer()
        }
        
    }
    
    private var HistoryListView: some View {
        LazyVStack (spacing: 12){
            HStack{
                ZStack{
                    Rectangle()
                        .fill(Color(red: 17/255, green: 17/255, blue: 17/255))
                        .frame(width: 170, height: 100)
                        .cornerRadius(14)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("3")
                            .font(.system(size: 28))
                            .foregroundStyle(.green)
                            .bold()
                        Text("Total resisted")
                            .font(.system(size: 14))
                            .opacity(0.5)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                }
                
                ZStack{
                    Rectangle()
                        .fill(Color(red: 17/255, green: 17/255, blue: 17/255))
                        .frame(width: 170, height: 100)
                        .cornerRadius(14)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("$3")
                            .font(.system(size: 28))
                            .foregroundStyle(.green)
                            .bold()
                        Text("Total saved")
                            .font(.system(size: 14))
                            .opacity(0.5)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    
                }
            }
            HStack{
                Text(Date.now.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                    .font(.system(size: 14))
                    .opacity(0.5)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            ForEach(0..<20, id: \.self){_ in
                HStack(spacing: 12) {
                    Rectangle()
                        .fill(.green)
                        .frame(width: 8, height: 8)
                        .cornerRadius(4)
                    
                    VStack(alignment: .leading) {
                        Text("15:12")
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                        Text("Malboro Gold")
                            .font(.system(size: 14))
                            .opacity(0.5)
                    }
                    
                    Spacer()
                    
                    Text("+$9.5")
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
    }

