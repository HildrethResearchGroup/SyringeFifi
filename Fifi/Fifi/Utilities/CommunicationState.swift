//
//  InstrumentState.swift
//  Fifi
//
//  Created by Connor Barnes on 7/21/21.
//

import SwiftUI
import PrinterController

// MARK: - Color
extension CommunicationState {
  var color: Color {
    switch self {
    case .notConnected:
      return .red
    case .notInitialized:
      return .purple
    case .connecting:
      return .orange
    case .busy:
      return .yellow
    case .ready, .reading:
      return .green
    case .blocked:
      return .brown
    }
  }
}
