//
//  CommentOperationView.swift
//  CommentOperationView
//
//  Created by Connor Barnes on 10/11/21.
//

import SwiftUI
import PrinterController

struct CommentOperationView: View {
  @Binding var configuration: CommentConfiguration
  
  var body: some View {
    TextField("Comment", text: $configuration.comment)
  }
}

struct CommentOperationView_Previews: PreviewProvider {
  static var previews: some View {
    CommentOperationView(configuration: .constant(.init()))
      .padding()
  }
}
