//
//  SettingsView.swift
//  CravelyApp
//
//  Created by ayman moh on 23/07/2026.
//


import SwiftUI

struct SettingsView: View {
    @State var habitCiggerate: Bool = true
    
    
    var body: some View {
        VStack {
            headerView
            habitView
            
            Spacer()
        }    .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
    private var headerView: some View {
        HStack {
            Text("Cravely")
                .font(.system(size: 28))
                .fontWeight(.heavy)
            
            Text("Settings")
                .font(.system(size: 28))
                .bold()
                .opacity(0.5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 30)
    }
    
    private var habitView: some View {
            VStack(spacing: 10) {
                Text("Habit")
                    .font(.system(size: 14))
                    .opacity(0.5)
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack{
                    Text("Type")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                    Spacer()
                    
                    Button {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            habitCiggerate.toggle()
                        }
                    } label: {
                        Text("🚬 Cigs")
                            .foregroundStyle(habitCiggerate ? .green : .white)
                            .frame(width: 100, height: 50)
                            .background(habitCiggerate ? .black : .red)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            habitCiggerate.toggle()
                        }
                    } label: {
                        Text("🌿 Cannabis")
                            .foregroundStyle(habitCiggerate ? .black : .white)
                            .frame(width: 160, height: 50)
                            .background(habitCiggerate ? .green : .red)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                        
                }
                
               
        }
            .padding(.horizontal, 16)
            .frame(maxHeight: .infinity)
            .frame(maxWidth: .infinity)
            .background(
                Color(red: 17/255, green: 17/255, blue: 17/255)
                    .cornerRadius(14)
            )
        }
    }

#Preview {
    SettingsView()
}
