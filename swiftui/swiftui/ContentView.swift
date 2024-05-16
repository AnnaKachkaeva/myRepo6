import SwiftUI

struct ContentView: View {
    @State private var isTapped = false

    var layout: AnyLayout {
        isTapped ? AnyLayout(DiagonalLayout()) : AnyLayout(HorizontalLayout())
    }

    var body: some View {
        layout {
            ForEach(0 ..< 7, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.cyan)
                    .onTapGesture {
                        withAnimation {
                            isTapped.toggle()
                        }
                    }
            }
        }
    }
}

struct DiagonalLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let width = proposal.replacingUnspecifiedDimensions().width
        let height = proposal.replacingUnspecifiedDimensions().height
        let subviewsAmount = CGFloat(subviews.count)
        let viewHeight = height / subviewsAmount
        let viewSize = CGSize(width: viewHeight, height: viewHeight)
        var currentY = Double(viewHeight/2)
        var currentX = bounds.minX

        for subview in subviews {
            let position = CGPoint(x: currentX, y: currentY)
            subview.place(at: position, anchor: .topLeading, proposal: ProposedViewSize(viewSize))
            currentY += viewHeight
            currentX += (width - viewHeight) / (subviewsAmount - 1)
        }
    }
}

struct HorizontalLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let viewWidth = proposal.replacingUnspecifiedDimensions().width
        let subviewsAmount = CGFloat(subviews.count)
        let spacing = 8.0 * (subviewsAmount - 1)
        let squareViewWidth = (viewWidth - spacing) / subviewsAmount
        let squareViewWSize = CGSize(width: squareViewWidth, height: squareViewWidth)
        var currentX = bounds.minX + squareViewWidth / 2

        for subview in subviews {
            let position = CGPoint(x: currentX, y: bounds.midY)
            subview.place(at: position, anchor: .center,proposal: ProposedViewSize(squareViewWSize))
            currentX += squareViewWidth + spacing / (subviewsAmount - 1)
        }
    }
}
