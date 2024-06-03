//
//  PreferencesView.swift
//  Fifi
//
//  Created by Connor Barnes on 7/21/21.
//

import SwiftUI
import SeeayaUI

struct PreferencesView: View {
    @AppStorage("xpsq8Address") var xpsq8Address = "0.0.0.0"
    @AppStorage("xpsq8Port") var xpsq8Port = 0
    
    @AppStorage("waveformAddress") var waveformAddress = "0.0.0.0"
    @AppStorage("waveformPort") var waveformPort = 0
    
    @AppStorage("multimeterAddress") private var multimeterAddress = "0.0.0.0"
    @AppStorage("multimeterPort") private var multimeterPort = 0
    
    //added for syringe pump
    @AppStorage("syringePumpAddress") private var syringePumpAddress = "0.0.0.0"
    @AppStorage("syringePumpPort") private var syringePumpPort = 0
    
    var body: some View {
        VStack {
            connectionPreferences(named: "XPS-Q8",
                                  address: $xpsq8Address,
                                  port: $xpsq8Port)
            
            Divider()
            
            connectionPreferences(named: "Waveform Generator",
                                  address: $waveformAddress,
                                  port: $waveformPort)
            
            Divider()
            
            connectionPreferences(named: "Multimeter",
                                  address: $multimeterAddress,
                                  port: $multimeterPort)
            
            //added for syringe pump
            Divider()
            
            connectionPreferences(named: "Syringe Pump",
                                  address: $syringePumpAddress,
                                  port: $syringePumpPort)
        }
        .padding()
    }
}

// MARK: - Subviews
private extension PreferencesView {
    @ViewBuilder
    func connectionPreferences(
        named name: String,
        address: Binding<String>,
        port: Binding<Int>
    ) -> some View {
        VStack {
            Text(name)
                .font(.title3)
            
            HStack {
                Text("Address: ")
                TextField("Address", text: address)
            }
            
            HStack {
                Text("Port: ")
                ValidatingTextField("Port", value: port) { value in
                    String(value)
                } validate: { string in
                    Int(string)
                }
            }
        }
    }
}

// MARK: - Previews
struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
