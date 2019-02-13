import SpriteKit

final class WildWildWestScene: SKScene {
    let cowboy = SKLabelNode(text: "🤠")
    let moneyBag = SKLabelNode(text: "💰")
    let coins = ["💰", "💵", "💴", "💶", "💷", "💎"]
    let enemies = ["🐍", "🦂", "🦈", "👻", "🕳"]
    var coin = SKLabelNode(text: "💰")
    var enemyArray = [SKLabelNode]()
    var gameOver = false
    var score = 0
    let scoreLabel = SKLabelNode(text: "0")

    func randomXPos() -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(view?.safeAreaLayoutGuide.layoutFrame.width ?? frame.midX))) + (view?.safeAreaLayoutGuide.layoutFrame.minX ?? 0)
    }


    func randomYPos() -> CGFloat {
        return CGFloat(arc4random_uniform(UInt32(view?.safeAreaLayoutGuide.layoutFrame.width ?? frame.midX))) + (view?.safeAreaLayoutGuide.layoutFrame.minX ?? 0)
    }

    override func sceneDidLoad() {
        drawScoreBoard()
        cowboy.position.x = frame.midX
        cowboy.position.y = frame.midY

        addChild(cowboy)
        addCoin()
        addEnemie()

        moneyBag.fontSize = 10
        moneyBag.alpha = 0

        cowboy.addChild(moneyBag)
        moneyBag.position.x = -12
        moneyBag.position.y = -20
    }

    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)

        for enemy in enemyArray {
            if cowboy.frame.intersects(enemy.frame) {
                setStateGameOver()
                break
            }
        }

        if cowboy.frame.intersects(coin.frame) {
            putCoinInBag()
            coin.removeFromParent()
            addCoin()
            addEnemie()

            score += 1
            scoreLabel.text = String(score)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard gameOver == false else { return }

        guard let touchLocation = touches.first?.location(in: self) else { return }

        let distance = distanceBetweenPoint(cowboy.position, andOtherPoint: touchLocation)

        let duration = TimeInterval(0.005 * distance)

        cowboy.run(.move(to: touchLocation , duration: duration))
    }

    private func drawScoreBoard() {
        scoreLabel.position.x = frame.midX
        scoreLabel.position.y = 80
        addChild(scoreLabel)
    }

    private func putCoinInBag() {
        moneyBag.alpha = 1
        moneyBag.fontSize = moneyBag.fontSize + 1
    }

    private func distanceBetweenPoint(_ point1: CGPoint, andOtherPoint point2: CGPoint) -> Float {
        return hypotf(Float(point2.x - point1.x), Float(point2.y - point1.y))
    }

    private func makeGround() -> SKShapeNode {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: 100)
        return SKShapeNode(rect: rect)
    }

    private func addCoin() {
        let coinNode = SKLabelNode(text: coins.random())

        self.coin = coinNode

        coinNode.position.x = randomXPos()
        coinNode.position.y = randomYPos()
        addChild(coinNode)
    }

    private func addEnemie() {
        let randomNumber = arc4random_uniform(10)
        guard randomNumber < 3 else { return }

        let enemyNode = SKLabelNode(text: enemies.random())

        self.enemyArray.append(enemyNode)

        enemyNode.position.x = randomXPos()
        enemyNode.position.y = randomYPos()
        addChild(enemyNode)
    }

    private func setStateGameOver() {
        gameOver = true

        let boom = SKLabelNode(text: "💥")
        cowboy.addChild(boom)

        let gameOverLabel = SKLabelNode(text: "GAME OVER")
        gameOverLabel.position.x = frame.midX
        gameOverLabel.position.y = frame.midY
        gameOverLabel.fontSize = 50
        gameOverLabel.fontColor = .red
        addChild(gameOverLabel)
    }
}
