//
//  ContentView.swift
//  Fifi
//
//  Created by Connor Barnes on 6/17/21.
//

import SwiftUI
import SeeayaUI
import PrinterController

struct ContentView: View {
    @EnvironmentObject private var printerController: PrinterController
    
    @AppStorage("waveformAddress") private var waveformAddress = "0.0.0.0"
    @AppStorage("waveformPort") private var waveformPort = 0
    @AppStorage("xpsq8Address") private var xpsq8Address = "0.0.0.0"
    @AppStorage("xpsq8Port") private var xpsq8Port = 0
    @AppStorage("multimeterAddress") private var multimeterAddress = "0.0.0.0"
    @AppStorage("multimeterPort") private var multimeterPort = 0
    
    @ObservedObject private var logger = Fifi.logger
    
    var body: some View {
        VStack(spacing: 0) {
            HSplitView {
                
                 OperationQueueView()
                     .frame(width: 500)
                     .padding()
                 
                
                
                 VStack {
                     ManualControlView()
                         .frame(minWidth: 500)
                         .padding()
                 }
                 
                
            }
            
            Divider()
            
            bottomBar
        }
        // There appears to be a glitch in SwiftUI for macOS where the default button style significantly slows down performance. The default menu style also slightly slows down performance.
        .buttonStyle(.plain)
        .menuStyle(.borderlessButton)
        .toolbar {
            toolbarContent
        }
        .alert("Alert", isPresented: alertShown) {
            Button("Continue") {
                alertShown.wrappedValue = false
            }
        } message: {
            Text(printerController.printerQueueState.modalComment ?? "nil")
        }
        .sheet(isPresented: timerShown) {
            timerShown.wrappedValue = false
        } content: {
            VStack(spacing: 16) {
                Label("Waiting…", systemImage: "clock")
                    .font(.title)
                
                let timeRemaining = printerController.printerQueueState.waitingTimeRemaining ?? 0.0
                Text("Time remaining: \(timeRemaining, specifier: "%.2f") seconds")
                    .padding(.horizontal)
                    .font(.monospacedDigit(.body)())
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

// MARK: - Subviews
private extension ContentView {
    @ViewBuilder
    var bottomBar: some View {
        HStack {
            if let lastLog = logger.lastLogOfLevelOrHigher[.warning] {
                HStack {
                    Spacer()
                        .frame(width: 4)
                    
                    lastLog.icon
                    
                    Text(lastLog.message)
                }
                .transition(.slide.combined(with: .opacity))
                .id(lastLog)
            }
            
            Spacer()
        }
        .frame(height: 26)
        .animation(.easeInOut, value: logger.lastLogOfLevelOrHigher)
        // TODO: This isn't providing behind-window blending
        .background(Material.bar)
    }
}

// MARK: - Toolbar
private extension ContentView {
    @ViewBuilder
    var toolbarContent: some View {
        Button {
            Task {
                await printerController.resumeQueue()
            }
        } label: {
            Image(systemName: "play.fill")
        }
        
        Spacer()
        
        Button {
            multimeterAction()
        } label: {
            Image(systemName: "bolt.fill")
                .foregroundColor(printerController.multimeterConnectionState.color)
        }
        .help(helpForInstrument(named: "Multimeter",
                                state: printerController.multimeterConnectionState))
        
        Button {
            waveformAction()
        } label: {
            Image(systemName: "waveform")
                .foregroundColor(printerController.waveformConnectionState.color)
        }
        .help(helpForInstrument(named: "Waveform generator",
                                state: printerController.waveformConnectionState))
        
        Button {
            xpsq8Action()
        } label: {
            Image(systemName: "move.3d")
                .foregroundColor(printerController.xpsq8ConnectionState.color)
        }
        .help(helpForInstrument(named: "XPS-Q8",
                                state: printerController.xpsq8ConnectionState))
    }
    
    func helpForInstrument(named name: String, state: CommunicationState) -> String {
        switch state {
        case .notConnected:
            return "\(name) not connected – press to connect"
        case .notInitialized:
            return "\(name) not initialized – press to initialize"
        case .connecting:
            return "\(name) connecting"
        case .busy:
            return "\(name) busy"
        case .ready, .reading:
            return "\(name) ready"
        case .blocked:
            return "\(name) blocked – this instrument is not in use but is blocked by an ongoing operation"
        }
    }
}

// MARK: - Helpers
private extension ContentView {
    var alertShown: Binding<Bool> {
        Binding {
            printerController.printerQueueState.modalComment != nil
        } set: { newValue in
            if newValue {
                printerController.printerQueueState.modalComment = "Unknown Alert"
            } else {
                printerController.printerQueueState.modalComment = nil
            }
        }
    }
    
    var timerShown: Binding<Bool> {
        Binding {
            printerController.printerQueueState.waitingTimeRemaining != nil
        } set: { newValue in
            if newValue {
                printerController.printerQueueState.waitingTimeRemaining = 10.0
            } else {
                printerController.printerQueueState.waitingTimeRemaining = nil
            }
        }
    }
    
    func waveformAction() {
        switch printerController.waveformConnectionState {
        case .notConnected:
            Task {
                logger.info("Connecting to waveform generator at \(waveformAddress)::\(waveformPort)")
                let configuration = VISAEthernetConfiguration(address: waveformAddress, port: waveformPort)
                await logger.tryOrError {
                    try await printerController.connectToWaveform(configuration: configuration)
                    logger.info("Connected to waveform generator at \(waveformAddress)::\(waveformPort)")
                } errorString: { error in
                    "Could not connect to waveform generator: \(error)"
                }
            }
        case .notInitialized:
            Task {
                logger.info("Initializing waveform generator")
                await logger.tryOrError {
                    try await printerController.initializeWaveform()
                    logger.info("Initialized waveform generator")
                } errorString: { error in
                    "Could not initialize waveform generator: \(error)"
                }
            }
        default:
            break
        }
    }
    
    func xpsq8Action() {
        switch printerController.xpsq8ConnectionState {
        case .notConnected:
            Task {
                logger.info("Connecting to XPS-Q8 at \(xpsq8Address)::\(xpsq8Port)")
                let configuration = XPSQ8Configuration(address: xpsq8Address, port: xpsq8Port)
                await logger.tryOrError {
                    try await printerController.connectToXPSQ8(configuration: configuration)
                    logger.info("Connected to XPS-Q8 at \(xpsq8Address)::\(xpsq8Port)")
                } errorString: { error in
                    "Could not connect to XPS-Q8: \(error)"
                }
            }
        case .notInitialized:
            Task {
                logger.info("Initializing XPS-Q8")
                await logger.tryOrError {
                    try await printerController.initializeXPSQ8()
                    logger.info("Initialized XPS-Q8")
                } errorString: { error in
                    "Could not initialize XPSQ8: \(error)"
                }
            }
        default:
            break
        }
    }
    
    func multimeterAction() {
        switch printerController.multimeterConnectionState {
        case .notConnected:
            Task {
                logger.info("Connecting to multimeter at \(multimeterAddress)::\(multimeterPort)")
                let configuration = VISAEthernetConfiguration(address: multimeterAddress, port: multimeterPort)
                await logger.tryOrError {
                    try await printerController.connectToMultimeter(configuration: configuration)
                    logger.info("Connected to multimeter at \(multimeterAddress)::\(multimeterPort)")
                } errorString: { error in
                    "Could not connect to multimeter: \(error)"
                }
            }
        case .notInitialized:
            Task {
                logger.info("Initializing multimeter")
                await logger.tryOrError {
                    try await printerController.initializeMultimeter()
                    logger.info("Initialized multimeter")
                } errorString: { error in
                    "Could not initialize multimeter: \(error)"
                }
            }
        default:
            break
        }
    }
}

// MARK: - Previews
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(PrinterController.staticPreview)
    }
}
