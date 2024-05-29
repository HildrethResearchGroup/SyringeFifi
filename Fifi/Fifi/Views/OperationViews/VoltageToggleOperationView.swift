//
//  VoltageToggleOperationView.swift
//  VoltageToggleOperationView
//
//  Created by Connor Barnes on 9/8/21.
//

import SwiftUI
import PrinterController

struct VoltageToggleOperationView: View {
  @Binding var configuration: VoltageToggleConfiguration
  
  var body: some View {
    Menu(configuration.turnOn ? "Turn on" : "Turn off") {
      Button("Turn on") {
        configuration.turnOn = true
      }
      
      Button("Turn off") {
        configuration.turnOn = false
      }
    }
    .id(UUID())
  }
}

// MARK: Previews
struct VoltageToggleOperationView_Previews: PreviewProvider {
  static var previews: some View {
    VoltageToggleOperationView(
      configuration: .constant(
        .init()
      )
    )
      .padding()
  }
}
