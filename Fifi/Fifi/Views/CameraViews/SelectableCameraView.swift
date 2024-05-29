//
//  SelectableCameraView.swift
//  DNVNew
//
//  Created by Connor Barnes on 5/9/22.
//

import SwiftUI
import AVFoundation

struct SelectableCameraView: View {
	@State var device: AVCaptureDevice?
	@State var recordingState = RecordingState()
	
	var body: some View {
		Group {
			VStack {
				HStack {
					Text("Device")
					Menu(device?.localizedName ?? "None") {
						ForEach(availableDevices) { availableDevice in
							Button(availableDevice.localizedName) {
								device = availableDevice
							}
						}
						
						Divider()
						
						Button("None") {
							device = nil
						}
					}
				}
				
				HStack {
					Text(recordingState.recordingURL?.path ?? "Select location")
					
					Button("Location…") {
						let panel = NSOpenPanel()
						panel.canChooseDirectories = true
						panel.canChooseFiles = false
						panel.allowsMultipleSelection = false
						panel.begin { response in
							if response == .OK {
								self.recordingState.recordingURL = panel.url
							}
						}
					}
					
					Spacer()
					
					Button(recordingState.isRecording ? "Stop recording…" : "Start recording…") {
						recordingState.isRecording.toggle()
					}
					.disabled(!recordingState.canRecord)
				}
			}
			.padding()
			
			DeviceCameraView(device: $device, recordingState: $recordingState)
		}
	}
}

// MARK: Helpers
extension SelectableCameraView {
	var availableDevices: [AVCaptureDevice] {
		return AVCaptureDevice.devices(for: .video)
	}
}

// MARK: Preview
struct CameraView_Previews: PreviewProvider {
	static var previews: some View {
		SelectableCameraView()
	}
}
