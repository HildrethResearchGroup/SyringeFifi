//
//  AlertOperationView.swift
//  Fifi
//
//  Created by Connor Barnes on 11/28/21.
//

import SwiftUI
import PrinterController

struct AlertOperationView: View {
	@Binding var configuration: AlertConfiguration
	
	var body: some View {
		HStack {
			Text("Comment")
			TextField("Comment", text: $configuration.comment)
		}
	}
}

struct AlertOperationView_Previews: PreviewProvider {
	static var previews: some View {
		AlertOperationView(configuration: .constant(.init()))
			.padding()
	}
}
