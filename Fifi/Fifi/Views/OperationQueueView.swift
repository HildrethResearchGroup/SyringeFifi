//
//  OperationQueueView.swift
//  OperationQueueView
//
//  Created by Connor Barnes on 9/8/21.
//

import SwiftUI
import PrinterController

struct OperationQueueView: View {
	@EnvironmentObject private var printerController: PrinterController
    @Environment(\.colorScheme) var colorScheme
	
	@State var selection: Set<UUID> = []
	
	var body: some View {
		VStack {
			heading
			
			//			List(queueState.queue.indices, id: \.self) { index in
			//				PrinterOperationView(operation: queueState.queue[index], operationIndex: index)
			//			}
			//			.listStyle(.plain)
			List(selection: $selection) {
				ForEach(queueState.queue) { $operation in
					PrinterOperationView(
						operation: $operation,
						operationIndex: queueState.queue.wrappedValue.firstIndex(of: operation)!
					)
					//.textFieldStyle(.automatic)
						.textFieldStyle(.squareBorder)
					.padding(4)
                    .background(.background)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
					.border(Color.secondary)
					.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
					.padding(.vertical, 6)
				}
				.onMove(perform: moveItemsAt(offsets:toOffset:))
				.listStyle(.plain)
			}
			
		}
		.disabled(printerController.printerQueueState.isRunning)
	}
	
	func moveItemsAt(offsets: IndexSet, toOffset: Int) {
		queueState.wrappedValue.queue.move(fromOffsets: offsets, toOffset: toOffset)
	}
}

// MARK: - Helpers
private extension OperationQueueView {
	var queueState: Binding<PrinterQueueState> {
		$printerController.printerQueueState
	}
}

// MARK: - Subviews
private extension OperationQueueView {
	var heading: some View {
		HStack {
			Text("Operation Queue")
				.font(.title3)
			Spacer()
			Menu {
				ForEach(0..<AnyPrinterOperation.allEmptyOperations.count) { index in
					let templateOperation = AnyPrinterOperation.allEmptyOperations[index]
					
					Button() {
						queueState.queue.wrappedValue.append(templateOperation)
					} label: {
						HStack {
							Image(systemName: templateOperation.thumbnailName)
							Text(templateOperation.name)
						}
					}
				}
			} label: {
				Image(systemName: "plus")
			}
			.menuStyle(.borderlessButton)
			.fixedSize()
		}
	}
}

// MARK: - Previews
struct OperationQueueView_Previews: PreviewProvider {
	static var previews: some View {
		OperationQueueView()
			.environmentObject(PrinterController.staticPreview)
			.padding()
	}
}
