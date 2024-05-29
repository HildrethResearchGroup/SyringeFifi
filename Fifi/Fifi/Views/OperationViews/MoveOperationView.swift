//
//  MoveOperationView.swift
//  Fifi
//
//  Created by Connor Barnes on 11/28/21.
//

import SwiftUI
import PrinterController
import SeeayaUI

struct MoveOperationView: View {
	@Binding var configuration: MoveConfiguration
	
	var body: some View {
		VStack {
			Menu(configuration.isAbsolute ? "Absolute" : "Relative") {
				Button("Absolute") {
					configuration.isAbsolute = true
				}
				
				Button("Relative") {
					configuration.isAbsolute = false
				}
			}
			.id(UUID())
			
			ForEach(0..<dimensionProperties.count) { index in
				let property = dimensionProperties[index]
				
				HStack {
					Text(property.0)
					textField(forProperty: property.1, name: property.0)
				}
			}
		}
	}
}

// MARK: - Subviews
private extension MoveOperationView {
	func textField(forProperty property: Binding<Double>, name: String) -> some View {
		TextField("", value: property, format:  appDefaultTextFieldNumberFormatter())
			.appDefaultTextFieldStyle()
	}
}

// MARK: - Helpers
private extension MoveOperationView {
	var dimensionProperties: [(String, Binding<Double>)] {
		[("X", $configuration.x), ("Y", $configuration.y), ("Z", $configuration.z)]
	}
}

// MARK: - Previews
struct MoveOperationView_Previews: PreviewProvider {
	static var previews: some View {
		MoveOperationView(configuration: .constant(.init()))
	}
}
