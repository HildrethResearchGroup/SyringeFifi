//
//  PrintLineOperationView.swift
//  Fifi
//
//  Created by Connor Barnes on 1/21/22.
//

import SwiftUI
import SeeayaUI
import PrinterController

struct PrintLineOperationView: View {
	@Binding var configuration: PrintLineConfiguration
	
	var body: some View {
		VStack(alignment: .leading, spacing: 10) {
			HStack () {
				Text("Direction:")
				
				Menu(configuration.dimension.rawValue) {
					ForEach([PrinterController.Dimension.x, .y]) { dimension in
						Button(dimension.rawValue) {
							configuration.dimension = dimension
						}
					}
				}.frame(width: 100)
			}
			
			HStack {
				Text("Line Length:")
				TextField("", value: $configuration.lineLength, format:  appDefaultTextFieldNumberFormatter())
					.appDefaultTextFieldStyle()
				Spacer()

				
				/*
				ValidatingTextField("Line length", value: $configuration.lineLength) { value in
					Self.numberFormatter.string(from: NSNumber(value: value)) ?? String(value)
				} validate: { string in
					Double(string)
				}
				*/
				
			}
			
			HStack {
				Text("Voltage:")
				TextField("", value: $configuration.voltage, format:  appDefaultTextFieldNumberFormatter(1))
					.appDefaultTextFieldStyle()
				
				Spacer()
				/*
				ValidatingTextField("Voltage", value: $configuration.voltage) { value in
					Self.numberFormatter.string(from: NSNumber(value: value)) ?? String(value)
				} validate: { string in
					Double(string)
				}
				*/
			}
			
			HStack {
				Text("Layers:")
				TextField("", value: $configuration.numberOfLayers, format: .number)
					.appDefaultTextFieldStyle()
				Spacer()
				/*
				ValidatingTextField("Layers", value: $configuration.numberOfLayers) { value in
					String(value)
				} validate: { string in
					Int(string)
				}
				 */
			}
			
			Toggle("Unidirectional:", isOn: $configuration.returnToStart)
		}
	}
	
	static let numberFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 3
		formatter.minimumFractionDigits = 3
		
		return formatter
	}()
}

// MARK: Previews
struct PrintLineOperationView_Previews: PreviewProvider {
	static var previews: some View {
		PrintLineOperationView(configuration: .constant(.init()))
	}
}
