//
//  ContentView.swift
//  NYC-ASP-Status
//
//  Created by Jia Sheng Ma on 8/15/22.
//

import SwiftUI

struct ContentView: View {
    @State private var aspStatus: ASPStatus = ASPStatus(aspStatus: "N/A", aspStatusDescription: "N/A")

    var body: some View {
        
        VStack(alignment: .leading) {
            Group {
                Text("\(aspStatus.date)")
                Text("NYC Alternate Side Parking Status:")
                Text("\(aspStatus.aspStatus)")
                    .foregroundColor(aspStatus.aspStatus == "SUSPENDED" ? .red: .green)
                    .fontWeight(.bold)
                Text("\(aspStatus.aspStatusDescription)")
                
            }.task {
                aspStatus = await getASPStatus()
            }.padding()
            
        }
        
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
