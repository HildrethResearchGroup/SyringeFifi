//
//  WaitOperationView.swift
//  Fifi
//
//  Created by Connor Barnes on 11/28/21.
//

import SwiftUI
import PrinterController
import SeeayaUI

struct WaitOperationView: View {
	@Binding var configuration: WaitConfiguration
	
	var body: some View {
		HStack {
			Text("Waiting time")
			
			
			TextField("", value: $configuration.time, format:  appDefaultTextFieldNumberFormatter(3))
				.appDefaultTextFieldStyle()
			
			
			/*
			 ValidatingTextField("Seconds", value: $configuration.time) { value in
				 String(value)
			 } validate: { string in
				 TimeInterval(string)
			 }
			 */
			
		}
	}
}

struct WaitOperationView_Previews: PreviewProvider {
	static var previews: some View {
		WaitOperationView(configuration: .constant(.init()))
	}
}
