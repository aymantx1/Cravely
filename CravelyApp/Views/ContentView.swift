//
//  ContentView.swift
//  CravelyApp
//
//  Created by ayman moh on 22/07/2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let greeting = "Good Morning Sun"
        let days = 14
        let total: Double = 20
        let ciggeretePrice = 20
        let ciggereteBrand = "Malboro Reds"

        VStack {
            HStack {
                Text("Cravely")
                    .font(.system(size: 28))
                    .fontWeight(.heavy)
                
                Text("Home")
                    .font(.system(size: 28))
                    .bold()
                    .opacity(0.5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 30)
            
            HStack{
                Text(greeting)
                    .font(.system(size: 14))
                    .opacity(0.5)
                Spacer()
                Text("🔥 \(days)d")
                    .bold()
                    .font(.system(size:14))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(RoundedRectangle(cornerRadius: 20)
                        .opacity(0.1)
                    )
            }
            .padding(.bottom, 20)
            VStack{
                HStack(){
                    Text("Total Saved")
                        .font(.system(size: 14))
                        .opacity(0.5)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack{
                    Text("$")
                        .font(.system(size: 36))
                        .opacity(0.5)
                        .fontWeight(.light)
                        .baselineOffset(25)
                    
                    //Fix the dollor sign position

                    Text(total, format: .number.precision(.fractionLength(2)))
                        .font(.system(size: 72))
                        .fontWeight(.heavy)
                    
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
               
                HStack(){
                    Text("\(ciggereteBrand)  •  $\(ciggeretePrice) per unit")
                        .font(.system(size: 14))
                        .opacity(0.5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(){
                    Rectangle()
                        .frame(height: 1)
                        .opacity(0.2)
                }
                .padding(.vertical, 24)

                
                HStack{
                    VStack{
                        HStack{
                            Text("200")
                                .font(.system(size: 22))
                                .fontWeight(.semibold)
                        }
                        HStack{
                            Text("Resisted")
                                .font(.system(size: 12))
                                .opacity(0.5)
                        }
                    }
                    Spacer()

                    Rectangle()
                        .frame(width: 1, height: 62)
                        .opacity(0.2)
                    VStack{
                        HStack{
                            Text("200")
                                .font(.system(size: 22))
                                .fontWeight(.semibold)
                        }
                        HStack{
                            Text("Days clean")
                                .font(.system(size: 12))
                                .opacity(0.5)
                        }
                    }
                    Spacer()
                    
                    Rectangle()
                        .frame(width: 1, height: 62)
                        .opacity(0.2)

                    VStack{
                        HStack{
                            Text("200")
                                .font(.system(size: 22))
                                .fontWeight(.semibold)
                        }
                        HStack{
                            Text("Saved today")
                                .font(.system(size: 12))
                                .opacity(0.5)
                        }
                    }
                    Spacer()
                }
                
                HStack(){
                    Rectangle()
                        .frame(height: 1)
                        .opacity(0.2)
                }
                .padding(.vertical, 8)
                VStack(alignment: .center, spacing: 20) {
                    Button {
                        let impact = UIImpactFeedbackGenerator(style: .medium)
                            impact.impactOccurred()
                    } label: {
                        ZStack {
                            Circle()
                                //warning darkmode
                                .stroke(.white, lineWidth: 0.5)
                                .frame(width: 220, height: 220)
                                .opacity(0.2)


                            Circle()
                                .frame(width: 180, height: 180)
                                .foregroundStyle(
                                    Color(
                                        red: 22 / 255,
                                        green: 22 / 255,
                                        blue: 22 / 255
                                    )
                                )

                            VStack(spacing: 15) {
                                Text("🚬")
                                    .font(.system(size: 42, weight: .bold))

                                Text("I crave one")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .buttonStyle(.plain)


                    Text("Tap to resist & save $\(ciggeretePrice)")
                        .font(.system(size: 14))
                        .opacity(0.5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
}

#Preview {
    ContentView()
}
