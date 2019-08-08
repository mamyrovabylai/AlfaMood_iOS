//
//  LineView.swift
//  AlphaMood
//
//  Created by Абылайхан on 8/2/19.
//  Copyright © 2019 Абылайхан. All rights reserved.
//

import Foundation

import Macaw

open class LineView: MacawView {
    
    private struct ScoreLine {
        
        let points: [(x: Double, y: Double)]
        let leftGradientColor: Int
        let rightGradientColor: Int
        
    }
    
    private var animationRect = Shape(form: Rect())
    
    private var animations = [Animation]()
    private var scoreLines = [ScoreLine]()
    private let cubicCurve = CubicCurveAlgorithm()
    private let chartWidth = 240
    private let chartHeight = 180
    private let milesCaptionWidth = 40
    private let backgroundLineSpacing = 40
    private var captionsX = [String]()
    private let captionsY = [SMILE_EMOJI, NEUTRAL_EMOJI , NEGATIVE_EMOJI ]
    private var title = TITLE_GRAPH
    var backgroundColorInt: Int!
    
    private var points = [Int]()
    
    var viewModel: GraphViewModel! {
        didSet{
            getMoodsInView()
        }
    }
    
    func getMoodsInView(){
        viewModel.getMoods(completion: { (moods, cpX) in
            if (moods.count > 0) && (cpX.count>0){
                self.title = TITLE_GRAPH
                self.captionsX = cpX
                self.points = moods
                self.play()
            } else {
                self.title = ZTITLE_GRAPH
                let text = Text(
                    text: self.title,
                    font: Font(name: FONT_GRAPH, size: 15),
                    fill: Color(val: 0xFFFFFF)
                )
                text.align = .mid
                text.place = .move(dx: Double(self.frame.width / 2), dy: 30)
                super.node = text
            }
            
        })
        backgroundColorInt = BACK_CLR_INT
    }
    
    func removeListener(){
        if viewModel != nil{
            viewModel.removeListener()
        }
    }
    
    private func createScene() {
        var points2 = [(x: Double, y: Double)]()
        for i in 0..<points.count {
            points2.append((x: Double(i)*40.0 , y: Double(points[i])))
        }
        scoreLines.removeAll()
        scoreLines.append(
            ScoreLine(
                points: points2,
                leftGradientColor: 0xff7200,
                rightGradientColor: 0xffff86
            )
        )
        
        
        
        let chartLinesGroup = Group()
        chartLinesGroup.place = Transform.move(dx: Double(milesCaptionWidth), dy: 0)
        if (points.count > 1) && (captionsX.count>1) {
        scoreLines.forEach { scoreLine in
            let dataPoints = scoreLine.points.map { CGPoint(x: $0.x, y: $0.y) }
            let controlPoints = self.cubicCurve.controlPointsFromPoints(dataPoints: dataPoints)
            var path: PathBuilder = MoveTo(x: scoreLine.points[0].x, y: scoreLine.points[0].y)
            for index in 0...dataPoints.count - 2 {
                path = path.cubicTo(
                    x1: Double(controlPoints[index].controlPoint1.x),
                    y1: Double(controlPoints[index].controlPoint1.y),
                    x2: Double(controlPoints[index].controlPoint2.x),
                    y2: Double(controlPoints[index].controlPoint2.y),
                    x: Double(dataPoints[index + 1].x),
                    y: Double(dataPoints[index + 1].y)
                )
            }
            let shape = Shape(
                form: path.build(),
                stroke: Stroke(
                    fill: LinearGradient(degree: 0, from: Color(val: scoreLine.leftGradientColor), to: Color(val: scoreLine.rightGradientColor)),
                    width: 2
                )
            )
            chartLinesGroup.contents.append(shape)
        }
        } else if (points.count == 1) && (captionsX.count == 1) {
            let shape = Shape(
                form: Circle(cx: Double(0), cy: Double(points[0]), r: 5), fill: Color(val: 0xfcc07c),
                stroke: Stroke(fill: Color(val: 0xff9e4f)))
            chartLinesGroup.contents.append(shape)
        }
        
        animationRect = Shape(
            form: Rect(x: 0, y: 0, w: Double(chartWidth + 1), h: Double(chartHeight + backgroundLineSpacing)),
            fill: Color(val: backgroundColorInt)
        )
        chartLinesGroup.contents.append(animationRect)
        let lineColor = Color.rgba(r: 255, g: 255, b: 255, a: 0.1)
        let captionColor = Color.rgba(r: 255, g: 255, b: 255, a: 0.5)
        var captionIndex = 0
        for index in 0..<captionsX.count {
            let x = Double(backgroundLineSpacing * index)
            let y2 =  Double(chartHeight)
            chartLinesGroup.contents.append(
                Line(
                    x1: x,
                    y1: 0,
                    x2: x,
                    y2: y2
                    ).stroke(fill: lineColor)
            )
            
                let text = Text(
                    text: captionsX[index],
                    font: Font(name: "Serif", size: 14),
                    fill: captionColor
                )
                text.align = .mid
                text.place = .move(
                    dx: x,
                    dy: y2 + 10
                )
                text.opacity = 1
                chartLinesGroup.contents.append(text)
                captionIndex += 1
            
        }
        
        let milesCaptionGroup = Group()
        for index in 0..<3 {
            let text = Text(
                text: captionsY[index],
                font: Font(name: "Serif", size: 30),
                fill: captionColor
            )
            text.place = .move(
                dx: 0,
                dy: Double((74) * index)
            )
            text.opacity = 1
            milesCaptionGroup.contents.append(text)
        }
        
        let viewCenterX = Double(self.frame.width / 2)
        let chartCenterX = viewCenterX - (Double(chartWidth / 2) + Double(milesCaptionWidth / 2))
        
        
        let text = Text(
            text: self.title,
            font: Font(name: "Serif", size: 24),
            fill: Color(val: 0xFFFFFF)
        )
        text.align = .mid
        text.place = .move(dx: Double(self.frame.width / 2), dy: 30)
        
        let chartGroup = [chartLinesGroup, milesCaptionGroup].group(place: Transform.move(dx: chartCenterX, dy: 90))
        self.node = [text, chartGroup].group()
        
        
        self.backgroundColor = UIColor(cgColor: Color(val: backgroundColorInt).toCG())
    }
    
    private func createAnimations() {
        animations.removeAll()
        animations.append(
            animationRect.placeVar.animation(to: Transform.move(dx: Double(self.frame.width), dy: 0), during: 2)
        )
    }
    
    open func play() {
        createScene()
        createAnimations()
        animations.forEach {
            $0.play()
        }
    }
    
}


