//
//  ManualMultimeterView.swift
//  Fifi
//
//  Created by Connor Barnes on 3/9/22.
//

import SwiftUI
import PrinterController

struct ManualMultimeterView: View {
	@EnvironmentObject private var printerController: PrinterController
	
	var body: some View {
		VStack(alignment: .leading) {
			HStack {
				Text("Voltage: \(voltageString)V")
			}
		}
	}
}

// MARK: - Helpers
private extension ManualMultimeterView {
	var voltageString: String {
		stringOrQuestionMarkIfOptional(printerController.multimeterState.rawResistance)
	}
	
	func stringOrQuestionMarkIfOptional<T>(_ value: T?) -> String {
		if let value = value {
			return "\(value)"
		} else {
			return "?"
		}
	}
}

// MARK: - Previews
struct ManualMultimeterView_Previews: PreviewProvider {
	static var previews: some View {
		ManualMultimeterView()
	}
}
