import SwiftUI

struct CustomCardShape: Shape {
    func path(in rect: CGRect) -> Path {
        let radius: CGFloat = 30
        let scoopRadius: CGFloat = 40

        var path = Path()

        path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))

        // Top left corner
        path.addArc(
            center: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
            radius: radius,
            startAngle: Angle(degrees: -90),
            endAngle: Angle(degrees: -180),
            clockwise: true
        )

        // Left edge
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - radius))

        // Bottom left corner
        path.addArc(
            center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
            radius: radius,
            startAngle: Angle(degrees: -180),
            endAngle: Angle(degrees: -270),
            clockwise: true
        )

        // Bottom edge
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.maxY))

        // Bottom right corner
        path.addArc(
            center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
            radius: radius,
            startAngle: Angle(degrees: -270),
            endAngle: Angle(degrees: 0),
            clockwise: true
        )

        // Right edge up to scoop
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + scoopRadius))

        // Concave scoop on top-right
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - scoopRadius, y: rect.minY),
            control: CGPoint(x: rect.maxX, y: rect.minY)
        )

        // Top edge
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.minY))

        return path
    }
}
