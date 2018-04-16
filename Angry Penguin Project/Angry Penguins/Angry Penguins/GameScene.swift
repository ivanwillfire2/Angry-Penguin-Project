import SpriteKit

class GameScene: SKScene {
    
    /* Game object connections */
    var catapultArm: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        /* Set reference to catapultArm SKSpriteNode */
        catapultArm = childNode(withName: "catapultArm") as! SKSpriteNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /* Add a new penguin to the scene */
        let penguin = MSReferenceNode(fileNamed: "Penguin")
        addChild(penguin)
        
        /* Move penguin to the catapult bucket area */
        penguin.avatar.position = catapultArm.position + CGPoint(x: 32, y: 50)
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
