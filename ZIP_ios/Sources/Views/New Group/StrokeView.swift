//
//  StrokeView.swift
//  ZIP_ios
//
//  Created by xiilab on 04/12/2018.
//  Copyright © 2018 park bumwoo. All rights reserved.
//

class StrokeView: UIView {
  override func draw(_ rect: CGRect) {
    let bezier = UIBezierPath()
    bezier.move(to: CGPoint(x: 0, y: self.bounds.height / 2.0))
    bezier.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height / 2.0))
    bezier.setLineDash([2.0], count: 1, phase: 0)
    bezier.lineWidth = 1
    bezier.lineCapStyle = .round
    bezier.close()
    UIColor.lightGray.setStroke()
    bezier.stroke()
  }
}
