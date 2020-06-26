import UIKit

class ViewController: UIViewController {
    lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Flips: \(flipCount)"
        }
    }
    
    var gameScore = 0 {
        didSet {
            scoreLabel.text = "Score: \(gameScore)"
        }
    }

    @IBOutlet weak var flipCountLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    override func viewDidLoad() {
        newGame()
    }
    
    @IBOutlet var backGroundUIView: UIView!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardIndex = cardButtons.firstIndex(of: sender) {
            let card = game.cards[cardIndex]
            if card.isMatched {
                return
            }
        }
        
        flipCount += 1
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    @IBOutlet weak var newGameButton: UIButton!
    
    @IBAction func onTouchNewGame(_ sender: UIButton) {
        newGame()
    }
    
    func newGame() {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        flipCount = 0
        (theme, _) = themes.randomElement()!
        emoji.removeAll()
        backGroundUIView.backgroundColor = backGroundColor
        flipCountLabel.textColor = primaryColor
        scoreLabel.textColor = primaryColor
        newGameButton.setTitleColor(primaryColor, for: UIControl.State.normal)
        
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : primaryColor
            }
        }
        gameScore = game.score
    }
    
    var emojiChoices = ["👻", "🎃", "🦇", "😈", "🕷", "🌜", "🔥", "🍭", "🍷"]
    
    var theme = "halloween" {
        didSet {
            emojiChoices = themes[theme]!["icons"] as! [String]
            backGroundColor = themes[theme]!["backGroundColor"] as! UIColor
            primaryColor = themes[theme]!["primaryColor"] as! UIColor
        }
    }
    
    var backGroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    var primaryColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    
    var themes = [
        "halloween": [
            "icons": ["👻", "🎃", "🦇", "😈", "🕷", "🌜", "🔥", "🍭", "🍷"],
            "backGroundColor": #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            "primaryColor": #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),
        ],
        "sports": [
            "icons": ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏄‍♂️", "🏉", "🏓", "⛳️"],
            "backGroundColor": #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
            "primaryColor": #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1),
        ],
        "animals": [
            "icons": ["🐶", "🦊", "🐼", "🦁", "🐷", "🐒", "🐔", "🐣", "🦄"],
            "backGroundColor": #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
            "primaryColor": #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1),
        ],
        "nature": [
            "icons": ["🌈", "⭐️", "🌤", "🌧", "❄️", "☔️", "🌬", "🌊", "⚡️"],
            "backGroundColor": #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
            "primaryColor": #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1),
        ],
        "faces": [
            "icons": ["😂", "😈", "😘", "😎", "🤓", "😤", "😡", "😱", "🤔"],
            "backGroundColor": #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            "primaryColor": #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1),
        ],
        "flag": [
            "icons": ["🇨🇦", "🇩🇪", "🇯🇵", "🇸🇬", "🇰🇷", "🇺🇸", "🇨🇳", "🇦🇺", "🏁"],
            "backGroundColor": #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
            "primaryColor": #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1),
        ],
    ]

    var emoji =  [Int:String]()
    
    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        
        return emoji[card.identifier] ?? "?";
    }
}
