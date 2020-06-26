import Foundation


class Concentration {
    var cards =  [Card]()
    var score = 0
    var cardLog = [Int: Set<Int>]() // identifier -> [index]
    
    var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex != nil {
                         return nil
                    }
                    foundIndex = index
                }
            }
            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int) {
        let id = cards[index].identifier
        if let logOfId = cardLog[id] {
            cardLog[id] = logOfId.union([index])
        } else {
            cardLog[id] = [index]
        }
        
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if card match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                }
                else {
                    if cardLog[id]!.count == 2 {
                        score -= 1
                    }
                    if cardLog[cards[matchIndex].identifier]?.count == 2 {
                        score -= 1
                    }
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        for _ in 1...numberOfPairsOfCards * 2 {
            let randomCardIndex = Int(arc4random_uniform(UInt32(numberOfPairsOfCards * 2)))
            let cardIndexToSwap = Int(arc4random_uniform(UInt32(numberOfPairsOfCards * 2)))
            
            let tempCard = cards[randomCardIndex]
            cards[randomCardIndex] = cards[cardIndexToSwap]
            cards[cardIndexToSwap] = tempCard
        }
    }
}
