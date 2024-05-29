//
//  DeviceCameraView.swift
//  DNVNew
//
//  Created by Connor Barnes on 5/9/22.
//

import SwiftUI
import AVFoundation

struct DeviceCameraView: NSViewControllerRepresentable {
	@Binding var device: AVCaptureDevice?
	@Binding var recordingState: RecordingState
	
	typealias NSViewControllerType = CameraViewController
	
	class Coordinator: CameraViewControllerDelegate {
		var canRecord: Binding<Bool>
		
		init(canRecord: Binding<Bool>) {
			self.canRecord = canRecord
		}
		
		func cameraViewController(_ viewController: CameraViewController, canRecordDidChange canRecord: Bool) {
			self.canRecord.wrappedValue = canRecord
		}
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(canRecord: $recordingState.canRecord)
	}
	
	func makeNSViewController(context: Context) -> CameraViewController {
		let controller = CameraViewController()
		controller.delegate = context.coordinator
		return controller
	}
	
	func updateNSViewController(_ nsViewController: CameraViewController, context: Context) {
		if nsViewController.device != device {
			nsViewController.device = device
		}
		
		if nsViewController.recordingURL != recordingState.recordingURL {
			nsViewController.recordingURL = recordingState.recordingURL
		}
		
		if nsViewController.isRecording != recordingState.isRecording {
			nsViewController.isRecording = recordingState.isRecording
		}
	}
}

extension DeviceCameraView {
	init(device: Binding<AVCaptureDevice?>) {
		self.init(device: device, recordingState: .constant(RecordingState()))
	}
}
