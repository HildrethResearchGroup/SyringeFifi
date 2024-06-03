import SwiftUI
import PrinterController

struct SyringePumpSettingsOperationView: View {
    @Binding var configuration: SyringePumpSettingsConfiguration
    @ObservedObject var controller = SyringePumpController()

    @State private var enable1: Bool = false
    @State private var enable2: Bool = false

    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Syringe Pump 1").font(.title2).padding(.top, -5)
                    Form {
                        // Flow Rate
                        HStack {
                            TextField("Flow Rate", text: $controller.flowRate1)
                        }
                        // Units
                        Picker("Units", selection: $controller.units1) {
                            ForEach(SyringePumpController.flowRateUnits1.allCases) { unit1 in
                                Text(unit1.rawValue).tag(unit1)
                            }
                        }
                        // Enable Toggle
                        Toggle(isOn: $enable1) {
                            Text("Enable Pump 1")
                        }
                        .onChange(of: enable1) { value in
                            if value {
                                controller.startPumping1(pump: "00")
                            } else {
                                controller.stopPumping1(pump: "00")
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                }
                CustomVerticalDivider(width: 1, height: 140, color: .gray)
                VStack {
                    Text("Syringe Pump 2").font(.title2).padding(.top, -5)
                    Form {
                        // Flow Rate
                        HStack {
                            TextField("Flow Rate", text: $controller.flowRate2)
                        }
                        // Units
                        Picker("Units", selection: $controller.units2) {
                            ForEach(SyringePumpController.flowRateUnits2.allCases) { unit2 in
                                Text(unit2.rawValue).tag(unit2)
                            }
                        }
                        // Enable Toggle
                        Toggle(isOn: $enable2) {
                            Text("Enable Pump 2")
                        }
                        .onChange(of: enable2) { value in
                            if value {
                                controller.startPumping2(pump: "01")
                            } else {
                                controller.stopPumping2(pump: "01")
                            }
                        }
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                }
            }
        }
    }
}

// MARK: - Helpers
private extension SyringePumpSettingsOperationView {
    // Helper methods for managing the configuration state can be added here if needed
}

// MARK: - Previews
struct SyringePumpSettingsOperationView_Previews: PreviewProvider {
    static var previews: some View {
        SyringePumpSettingsOperationView(configuration: .constant(.init()))
            .padding()
    }
}
