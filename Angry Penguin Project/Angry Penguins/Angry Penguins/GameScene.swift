import SpriteKit

class GameScene: SKScene {
    
    /* Game object connections */
    var catapultArm: SKSpriteNode!
    /* Level loader holder */
    var levelHolder: SKNode!
    
    /* Tracking helpers */
    var trackerNode: SKNode? {
        didSet {
            if let trackerNode = trackerNode {
                /* Set tracker */
                lastTrackerPosition = trackerNode.position
            }
        }
    }
    var lastTrackerPosition = CGPoint(x: 0, y: 0)
    var lastTimeInterval:TimeInterval = 0
    
    override func didMove(to view: SKView) {
        /* Set reference to catapultArm SKSpriteNode */
        catapultArm = childNode(withName: "catapultArm") as! SKSpriteNode!
        
        /* Set reference to levelHolder SKNode */
        levelHolder = childNode(withName: "levelHolder")
        
        /* Load Level 1 */
        let resourcePath = Bundle.main.path(forResource: "Level1", ofType: "sks")
        let level = SKReferenceNode (url: URL (fileURLWithPath: resourcePath!))
        levelHolder.addChild(level)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /* Add a new penguin to the scene */
        let penguin = MSReferenceNode(fileNamed: "Penguin")
        addChild(penguin)
        
        
        /* Move penguin to the catapult bucket area */
        if catapultArm != nil{
            penguin.avatar.position = (catapultArm?.position)! + CGPoint(x: 32, y: 50)
        }
        
        /* Impulse vector */
        let launchDirection = CGVector(dx: 1, dy: 0)
        let force = launchDirection * 300
        
        print(force)
        
        /* Apply impulse to penguin */
        penguin.avatar.physicsBody?.applyImpulse(force)
        
        /* Set tracker to follow penguin */
        trackerNode = penguin.avatar
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        /* Check there is a node to track and camera is present */
        if let trackerNode = trackerNode, let camera = camera {
            
            /* Calculate horizontal distance to move */
            let moveDistance = trackerNode.position.x - lastTrackerPosition.x
            
            /* Duration is time between updates */
            let moveDuration = currentTime - lastTimeInterval
            
            /* Create a move action for the camera */
            let moveCamera = SKAction.moveBy(x: moveDistance, y: 0, duration: moveDuration)
            camera.run(moveCamera)
            
            /* Store last tracker position */
            lastTrackerPosition = trackerNode.position
        }
        
        /* Store current update step time */
        lastTimeInterval = currentTime
    }
}


