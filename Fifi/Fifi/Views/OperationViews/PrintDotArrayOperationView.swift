//
//  PrintDotArrayOperationView.swift
//  Fifi
//
//  Created by Connor Barnes on 7/15/22.
//

import SwiftUI
import PrinterController
import SeeayaUI

struct PrintDotArrayOperationView: View {
	@Binding var configuration: PrintDotArrayConfiguration
	
	
	
	var body: some View {
		VStack {
            HStack(){
                Text("Spacing")
                TextField("Spacing", value: $configuration.spacing, format: appDefaultTextFieldNumberFormatter(3))
                    .appDefaultTextFieldStyle()
            }
           
            HStack() {
                Text("Voltage")
                TextField("Voltage", value: $configuration.voltage, format: appDefaultTextFieldNumberFormatter(3))
                    .appDefaultTextFieldStyle()
            }
            
            HStack() {
                Text("Voltage Time")
                TextField("VoltageTime", value: $configuration.voltageTime, format: appDefaultTextFieldNumberFormatter(3))
                    .appDefaultTextFieldStyle()
            }
            
           
            HStack() {
                Text("Number of X Dots")
                TextField("Number of Dots", value: $configuration.numberOfXDots, format: .number)
                    .appDefaultTextFieldStyle()
            }
            
            HStack() {
                Text("Number of Y Dots")
                TextField("Number of Dots", value: $configuration.numberOfYDots, format: .number)
                    .appDefaultTextFieldStyle()
            }
            
            HStack() {
                Text("Number of Layers")
                TextField("Number of Layers", value: $configuration.numberOfLayers, format: .number)
                    .appDefaultTextFieldStyle()
            }
			
		}
	}
}
