//
//  FifiApp.swift
//  Fifi
//
//  Created by Connor Barnes on 6/17/21.
//

import SwiftUI
import PrinterController

@main
struct FifiApp: App {
  init() {
    AnyPrinterOperation.DynamicDispatch.shared
      .register(
        kind: .comment,
        operation: .commentOperation(body: CommentOperationView.init)
      )
      .register(
        kind: .voltageToggle,
        operation: .voltageToggleOperation(body: VoltageToggleOperationView.init)
      )
      .register(
        kind: .waveformSettings,
        operation: .waveformSettingsOperation(body: WaveformSettingsOperationView.init)
      )
			.register(
				kind: .home,
				operation: .homeOperation(body: HomeOperationView.init)
			)
			.register(
				kind: .alert,
				operation: .alertOperation(body: AlertOperationView.init)
			)
			.register(
				kind: .wait,
				operation: .waitOperation(body: WaitOperationView.init)
			)
			.register(
				kind: .move,
				operation: .moveOperation(body: MoveOperationView.init)
			)
			.register(
				kind: .printLine,
				operation: .printLineOperation(body: PrintLineOperationView.init)
			)
			.register(
				kind: .gapHeightCalibrate,
				operation: .gapHeightCalibrateOperation(body: GapHeightCalibrateOperationView.init)
			)
			.register(
				kind: .printDotArray,
				operation: .printDotArrayOperation(body: PrintDotArrayOperationView.init)
			)
      .finalize()
		
		Task { [self] in
			await setModel(printerController: PrinterController())
		}
  }
  
	func setModel(printerController: PrinterController) async {
		model.printerController = printerController
	}
	
	var model = Model()
  
  var body: some Scene {
    WindowGroup {
			if let printerController = model.printerController {
				ContentView()
					.environmentObject(printerController)
					.onReceive(
						NotificationCenter.default.publisher(for: NSApplication.willUpdateNotification)
					) { _ in
						for window in NSApplication.shared.windows {
							if window.title == OpenWindows.mainWindow.title {
								window.standardWindowButton(NSWindow.ButtonType.closeButton)?.isEnabled = false
								break
							}
						}
					}
			} else {
				ProgressView()
					.padding()
					.frame(maxWidth: .infinity, maxHeight: .infinity)
			}
    }
    .commands {
      commands()
    }
    .handlesExternalEvents(matching: ["mainWindow"])
    
    WindowGroup("Logs") {
      LogView()
    }
    .handlesExternalEvents(matching: ["logWindow"])
    
    Settings {
      PreferencesView()
        .frame(width: 240, height: 360, alignment: .top)
    }
  }
}

// MARK: Open Windows
enum OpenWindows: String, CaseIterable, Identifiable {
  case mainWindow
  case logWindow
  
  var title: String {
    switch self {
    case .mainWindow:
      return "Fifi"
    case .logWindow:
      return "Logs"
    }
  }
  
  func open() {
    for window in NSApplication.shared.windows {
      if title == window.title {
        window.makeKeyAndOrderFront(nil)
        return
      }
    }
    
    if let url = URL(string: "fifi://\(self.rawValue)") {
      NSWorkspace.shared.open(url)
    }
  }
	
	var id: String {
		rawValue
	}
}
