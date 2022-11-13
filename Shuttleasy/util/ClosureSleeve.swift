//
//  ClosureSleeve.swift
//  Shuttleasy
//
//  Created by Oğuzhan Aslan on 13.11.2022.
//

import Foundation

class ClosureSleeve {
  let closure: () -> ()

  init(attachTo: AnyObject, closure: @escaping () -> ()) {
    self.closure = closure
    objc_setAssociatedObject(attachTo, "[\(arc4random())]", self, .OBJC_ASSOCIATION_RETAIN)
  }

  @objc func invoke() {
    closure()
  }
}
