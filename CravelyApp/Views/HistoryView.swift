//
//  HistoryView.swift
//  CravelyApp
//
//  Created by ayman moh on 23/07/2026.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        VStack {
            headerView
           
        }
        
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

}

#Preview {
    HistoryView()
}
