//
//  CameraViewController.swift
//  DNVNew
//
//  Created by Connor Barnes on 5/9/22.
//

import Cocoa
import AVFoundation
import SwiftUI

class CameraViewController: NSViewController {
	@IBOutlet weak var cameraView: NSView!
	let session = AVCaptureSession()
	var previewLayer: AVCaptureVideoPreviewLayer!
	var lastInput: AVCaptureInput?
	var delegate: CameraViewControllerDelegate?
	var movieFileOutput = AVCaptureMovieFileOutput()
	
	let queue = DispatchQueue(label: "VideoFeed")
	
	var device: AVCaptureDevice? {
		didSet {
			queue.async {
				self.isRecording = false
				if let device = self.device {
					if let lastInput = self.lastInput {
						self.session.removeInput(lastInput)
					}
					
					do {
						self.lastInput = try AVCaptureDeviceInput(device: device)
						self.session.addInput(self.lastInput!)
					} catch {
						self.lastInput = nil
					}
				} else {
					if let lastInput = self.lastInput {
						self.session.removeInput(lastInput)
					}
				}
				
				DispatchQueue.main.async {
					self.updateCanRecord()
				}
			}
		}
	}
	
	var isRecording = false {
		didSet {
			if isRecording {
				// Start recording
				guard canRecord,
							let recordingURL = recordingURL
				else {
					DispatchQueue.main.asyncAfter(deadline: .now()) {
						self.updateCanRecord()
					}
					return
				}
				
				let url = recordingURL
					.appendingPathComponent("recording \(timestamp)")
					.appendingPathExtension("mov")
				
				movieFileOutput.startRecording(to: url, recordingDelegate: self)
			} else {
				// Stop recording
				movieFileOutput.stopRecording()
			}
		}
	}
	
	var recordingURL: URL? {
		didSet {
			DispatchQueue.main.asyncAfter(deadline: .now()) {
				self.updateCanRecord()
			}
		}
	}
	
	var timestamp: String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH_mm_ss_SSSS"
		return dateFormatter.string(from: Date())
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		cameraView?.wantsLayer = true
		cameraView?.layer?.backgroundColor = .black
		session.sessionPreset = .high
		session.addOutput(movieFileOutput)
		// Preview
		previewLayer = AVCaptureVideoPreviewLayer(session: session)
		previewLayer.frame = cameraView.bounds
		
		previewLayer.videoGravity = .resizeAspect
		cameraView?.layer?.addSublayer(previewLayer)
	}
	
	override func viewDidLayout() {
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		previewLayer.frame = cameraView.bounds
		CATransaction.commit()
	}
	
	override func viewDidAppear() {
		session.startRunning()
	}
	
	override func viewDidDisappear() {
		session.stopRunning()
	}
}

// MARK: State Updates
extension CameraViewController {
	private func updateCanRecord() {
		delegate?.cameraViewController(self, canRecordDidChange: canRecord)
	}
	
	private var canRecord: Bool {
		return self.device != nil && self.lastInput != nil && self.recordingURL != nil
	}
}

// MARK: AVCaptureFileOutputRecordingDelegate
extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
	func fileOutput(
		_ output: AVCaptureFileOutput,
		didFinishRecordingTo outputFileURL: URL,
		from connections: [AVCaptureConnection],
		error: Error?
	) {
		print("Finished recording to \(outputFileURL)")
		if let error = error {
			print("ERROR: \(error)")
		}
	}
	
	func fileOutput(
		_ output: AVCaptureFileOutput,
		didStartRecordingTo fileURL: URL,
		from connections: [AVCaptureConnection]
	) {
		print("Started recording to \(fileURL)")
	}
}
