import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        Grid(viewModel.cards) { card in
            CardView(card: card).onTapGesture {
                self.viewModel.chooseCard(card: card)
            }
            .padding(4)
        }
        .foregroundColor(Color.orange)
        .padding()
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    func body(for size: CGSize) -> some View {
        ZStack {
            if card.isFaceUp {
                RoundedRectangle(cornerRadius: CARD_RADIUS).fill(Color.white)
                RoundedRectangle(cornerRadius: CARD_RADIUS).stroke(lineWidth: CARD_STROKE_WIDTH)
                Text(card.content)
            } else {
                if !card.isMatched {
                    RoundedRectangle(cornerRadius: CARD_RADIUS).fill(Color.orange)
                }
            }
        }
        .font(Font.system(size: min(size.width, size.height) * FONT_SCALING_FACTOR))
    }
    
    let CARD_RADIUS: CGFloat = 10.0
    let CARD_STROKE_WIDTH: CGFloat = 3
    let FONT_SCALING_FACTOR: CGFloat = 0.75
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EmojiMemoryGameView(viewModel: EmojiMemoryGame())
    }
}
