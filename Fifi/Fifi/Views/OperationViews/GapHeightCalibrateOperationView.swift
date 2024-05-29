//
//  GapHeightCalibrateOperationView.swift
//  Fifi
//
//  Created by Connor Barnes on 3/9/22.
//

import SwiftUI
import PrinterController
import SeeayaUI

struct GapHeightCalibrateOperationView: View {
	@Binding var configuration: GapHeightCalibrateOperationConfiguration
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text("Target resistance")
				
				TextField("", value: $configuration.targetVoltage, format:  appDefaultTextFieldNumberFormatter(1))
					.appDefaultTextFieldStyle()
				
				/*
				ValidatingTextField("Target resistance", value: $configuration.targetVoltage) { value in
					Self.numberFormatter.string(from: NSNumber(value: value)) ?? String(value)
				} validate: { string in
					Double(string)
				}
				 */
			}
			
			HStack {
				Text("Displacement step")
				
				TextField("", value: $configuration.displacementAmount, format:  appDefaultTextFieldNumberFormatter())
					.appDefaultTextFieldStyle()
			}
		}
	}
}

// MARK: - Helpers
private extension GapHeightCalibrateOperationView {
	static let numberFormatter: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 3
		formatter.minimumFractionDigits = 3
		
		return formatter
	}()
}

// MARK: - Previews
struct GapHeightCalibrateOperationView_Previews: PreviewProvider {
	static var previews: some View {
		GapHeightCalibrateOperationView(configuration: .constant(.init()))
	}
}
