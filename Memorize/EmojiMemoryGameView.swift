import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation(.easeInOut) {
                    self.viewModel.reset()
                }
            }, label: {
                Text("New Game")
            })
            Grid(viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.linear) {
                        self.viewModel.chooseCard(card: card)
                    }
                }
                .padding(4)
            }
            .foregroundColor(Color.orange)
            .padding()
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @State private var animatedBonusRemaining: Double = 0
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(
                            startAngle: Angle.degrees(0-TIMER_ANGLE_DIFF),
                            endAngle: Angle.degrees(-animatedBonusRemaining*360-TIMER_ANGLE_DIFF)
                        )
                            .onAppear { self.startBonusTimeAnimation() }
                    } else {
                        Pie(
                            startAngle: Angle.degrees(0-TIMER_ANGLE_DIFF),
                            endAngle: Angle.degrees(-card.bonusRemaining*360-TIMER_ANGLE_DIFF)
                        )
                    }
                }
                    .opacity(TIMER_OPACITY)
                    .padding(TIMER_PADDING)
                Text(card.content)
                    .font(Font.system(size: min(size.width, size.height) * FONT_SCALING_FACTOR))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default)
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(.scale)
        }
    }
    
    private func startBonusTimeAnimation() {
        animatedBonusRemaining = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animatedBonusRemaining = 0
        }
    }

    private let FONT_SCALING_FACTOR: CGFloat = 0.7
    private let TIMER_PADDING: CGFloat = 5.0
    private let TIMER_OPACITY = 0.4
    private let TIMER_ANGLE_DIFF = 90.0
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.chooseCard(card: game.cards.first!)
        return EmojiMemoryGameView(viewModel: game)
    }
}
