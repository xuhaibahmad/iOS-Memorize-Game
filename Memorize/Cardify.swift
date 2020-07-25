import SwiftUI

struct Cardify: AnimatableModifier {
    var rotation: Double
    
    var isFaceUp: Bool {
        rotation < 90
    }
    
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    init(isFaceUp: Bool) {
        rotation = isFaceUp ? 0 : 180
    }
    
    func body(content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: CARD_RADIUS).fill(Color.white)
                RoundedRectangle(cornerRadius: CARD_RADIUS).stroke(lineWidth: CARD_STROKE_WIDTH)
                content
            }
            .opacity(isFaceUp ? 1 : 0)
            RoundedRectangle(cornerRadius: CARD_RADIUS)
                .fill(Color.orange)
                .opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    private let CARD_RADIUS: CGFloat = 10.0
    private let CARD_STROKE_WIDTH: CGFloat = 3
    private let FONT_SCALING_FACTOR: CGFloat = 0.7
}

extension View {
    func cardify(isFaceUp: Bool) -> some View {
        self.modifier(Cardify(isFaceUp: isFaceUp))
    }
}
