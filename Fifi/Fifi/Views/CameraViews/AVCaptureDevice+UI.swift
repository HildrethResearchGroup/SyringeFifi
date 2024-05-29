//
//  AVCaptureDevice+localizedName.swift
//  DNVNew
//
//  Created by Connor Barnes on 5/9/22.
//

import AVFoundation
import SwiftUI

extension AVCaptureDevice.Format {
	var localizedName: String {
		guard CMFormatDescriptionGetMediaType(formatDescription) == kCMMediaType_Video else { return "nil" }
		
		let extensionKey = kCMFormatDescriptionExtension_FormatName
		let formatName = CMFormatDescriptionGetExtension(formatDescription, extensionKey: extensionKey) as! CFString?
		let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription)
		return "\(formatName as String? ?? "nil"), \(dimensions.width) x \(dimensions.height))"
	}
}

extension AVCaptureDevice: Identifiable {
	public var id: ObjectIdentifier {
		return ObjectIdentifier(self)
	}
}
