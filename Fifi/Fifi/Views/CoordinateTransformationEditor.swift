//
//  CoordinateTransformationEditor.swift
//  CoordinateTransformationEditor
//
//  Created by Connor Barnes on 7/22/21.
//

import SwiftUI

struct CoordinateTransformationEditor: View {
  @Binding var coordinateTransformer: CoordinateTransformer
  
  let lineCount = 20
  
  var body: some View {
    preview
  }
}

// MARK: - Subviews
private extension CoordinateTransformationEditor {
  @ViewBuilder
  var preview: some View {
    Canvas { (context: inout GraphicsContext, size: CGSize) in
      (0..<lineCount).forEach { index in
        let x = 2 * size.width / Double(lineCount) * Double(index - lineCount / 2)
        var line = Path()
        
        let absoluteStart: Point3D = (x, -size.height, 0.0)
        let relativeStart = coordinateTransformer.transform(absoluteStart)
        
        let absoluteEnd: Point3D = (x, size.height, 0.0)
        let relativeEnd = coordinateTransformer.transform(absoluteEnd)
        
        line.move(to: CGPoint(x: relativeStart.x + size.width / 2,
                              y: relativeStart.y + size.height / 2))
        line.addLine(to: CGPoint(x: relativeEnd.x + size.width / 2,
                                 y: relativeEnd.y + size.height / 2))
        context.stroke(line, with: .color(.black))
      }
      
      (0..<lineCount).forEach { index in
        let y = 2 * size.height / Double(lineCount) * Double(index - lineCount / 2)
        var line = Path()
        
        let absoluteStart: Point3D = (-size.width, y, 0.0)
        let relativeStart = coordinateTransformer.transform(absoluteStart)
        
        let absoluteEnd: Point3D = (size.width, y, 0.0)
        let relativeEnd = coordinateTransformer.transform(absoluteEnd)
        
        line.move(to: CGPoint(x: relativeStart.x + size.width / 2,
                              y: relativeStart.y + size.height / 2))
        line.addLine(to: CGPoint(x: relativeEnd.x + size.width / 2,
                                 y: relativeEnd.y + size.height / 2))
        context.stroke(line, with: .color(.black))
      }
      
      _ = {
        let absolute: Point3D = (0.95 * size.width, size.height / 2, 0)
        let relative = coordinateTransformer.transform(absolute)
        
//        let circle =
//
//        context.fill(Path(ellipseIn: CGRect.), with: <#T##GraphicsContext.Shading#>)
        context.draw(Text("+x"), at: CGPoint(x: relative.x, y: relative.y))
        
      }()
    }
    .aspectRatio(1, contentMode: .fit)
  }
}

// MARK: - Previews
struct CoordinateTransformationEditor_Previews: PreviewProvider {
  static var previews: some View {
    CoordinateTransformationEditor(
      coordinateTransformer: .constant(CoordinateTransformer(transformations: [
//        .flip(.vertical),
//        .translation((x: 1, y: 3, z: 1)),
        .zRotation(.degrees(0))
      ]))
    )
  }
}
