//
//  CoordinateTransformer.swift
//  CoordinateTransformer
//
//  Created by Connor Barnes on 7/22/21.
//

import Foundation

typealias Point3D = (x: Double, y: Double, z: Double)

protocol CoordinateTransformation {
  func transform(_ coordinate: Point3D) -> Point3D
  func reverseTransform(_ coordinate: Point3D) -> Point3D
}

struct CoordinateTransformer: CoordinateTransformation {
  var transformations: [CoordinateTransformation]
  
  func transform(_ coordinate: Point3D) -> Point3D {
    transformations.reduce(coordinate) { coordinate, transformation in
      transformation.transform(coordinate)
    }
  }
  
  func reverseTransform(_ coordinate: Point3D) -> Point3D {
    transformations.reversed().reduce(coordinate) { coordinate, transformation in
      transformation.reverseTransform(coordinate)
    }
  }
}

// MARK: - Rotation
extension CoordinateTransformer {
  enum ZRotation: CoordinateTransformation {
    case radians (Double)
    case degrees (Double)
    
    func transform(_ coordinate: Point3D) -> Point3D {
      let distance = sqrt(coordinate.x * coordinate.x + coordinate.y * coordinate.y)
      let angle = atan2(coordinate.y, coordinate.x)
      let newAngle = angle + self.inRadians
      let newX = cos(newAngle) * distance
      let newY = sin(newAngle) * distance
      
      return (newX, newY, coordinate.z)
    }
    
    func reverseTransform(_ coordinate: Point3D) -> Point3D {
      let distance = sqrt(coordinate.x * coordinate.x + coordinate.y * coordinate.y)
      let angle = atan2(coordinate.y, coordinate.x)
      let newAngle = angle - self.inRadians
      let newX = cos(newAngle) * distance
      let newY = sin(newAngle) * distance
      
      return (newX, newY, coordinate.z)
    }
    
    var inRadians: Double {
      switch self {
      case .radians(let radians):
        return radians
      case .degrees(let degrees):
        return degrees * .pi / 180
      }
    }
    
    var inDegrees: Double {
      switch self {
      case .radians(let radians):
        return radians * 180 / .pi
      case .degrees(let degrees):
        return degrees
      }
    }
  }
}

// MARK: - Translation
extension CoordinateTransformer {
  struct Translation: CoordinateTransformation {
    var offset: Point3D
    
    func transform(_ coordinate: Point3D) -> Point3D {
      (coordinate.x + offset.x, coordinate.y + offset.y, coordinate.z + offset.z)
    }
    
    func reverseTransform(_ coordinate: Point3D) -> Point3D {
      (coordinate.x - offset.x, coordinate.y - offset.y, coordinate.z - offset.z)
    }
  }
}

// MARK: - Flip
extension CoordinateTransformer {
  enum Flip: CoordinateTransformation {
    case horizontal
    case vertical
    
    func transform(_ coordinate: Point3D) -> Point3D {
      switch self {
      case .horizontal:
        return (-coordinate.x, coordinate.y, coordinate.z)
      case .vertical:
        return (coordinate.x, -coordinate.y, coordinate.z)
      }
    }
    
    func reverseTransform(_ coordinate: Point3D) -> Point3D {
      switch self {
      case .horizontal:
        return (-coordinate.x, coordinate.y, coordinate.z)
      case .vertical:
        return (coordinate.x, -coordinate.y, coordinate.z)
      }
    }
  }
}

// MARK: Static Accessors
extension CoordinateTransformation where Self == CoordinateTransformer.Flip {
  static func flip(
    _ flip: CoordinateTransformer.Flip
  ) -> CoordinateTransformer.Flip {
    flip
  }
}

extension CoordinateTransformation where Self == CoordinateTransformer.Translation {
  static func translation(
    _ translation: Point3D
  ) -> CoordinateTransformer.Translation {
    .init(offset: translation)
  }
}

extension CoordinateTransformation where Self == CoordinateTransformer.ZRotation {
  static func zRotation(
    _ rotation: CoordinateTransformer.ZRotation
  ) -> CoordinateTransformer.ZRotation {
    rotation
  }
}
