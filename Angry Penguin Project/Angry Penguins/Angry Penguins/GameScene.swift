import SpriteKit

class GameScene: SKScene {
    
    /* Game object connections */
    var catapultArm: SKSpriteNode!
    var catapult: SKSpriteNode!
    var cantileverNode: SKSpriteNode!
    var touchNode: SKSpriteNode!
    /* Level loader holder */
    var levelHolder: SKNode!
    
    /* Tracking helpers */
    var trackerNode: SKNode? {
        didSet {
            if let trackerNode = trackerNode {
                /* Set tracker */
                lastTrackerPosition = trackerNode.position
                print(lastTrackerPosition)
            }
        }
    }
    var lastTrackerPosition = CGPoint(x: 0, y: 0)
    var lastTimeInterval:TimeInterval = 0
    
    /* UI Connections */
    var buttonRestart: MSButtonNode!
    
    /* Physics helpers */
    var touchJoint: SKPhysicsJointSpring?
    
    override func didMove(to view: SKView) {
        /* Set reference to catapultArm SKSpriteNode */
        catapultArm = childNode(withName: "catapultArm") as! SKSpriteNode!
        /* Set reference to catapult SKSpriteNode */
        catapult = childNode(withName: "catapult") as! SKSpriteNode!
        /* Set reference to cantileverNode SKSpriteNode */
        cantileverNode = childNode(withName: "cantileverNode") as! SKSpriteNode!
        /* Set reference to touchNode SKSpriteNode */
        touchNode = childNode(withName: "touchNode") as! SKSpriteNode!
        
        /* Set reference to levelHolder SKNode */
        levelHolder = childNode(withName: "levelHolder")
        
        /* Load Level 1 */
        let resourcePath = Bundle.main.path(forResource: "Level1", ofType: "sks")
        let level = SKReferenceNode (url: URL (fileURLWithPath: resourcePath!))
        levelHolder.addChild(level)
        
        /* Set reference to buttonRestart SKSpriteNode */
        buttonRestart = childNode(withName: "//buttonRestart") as! MSButtonNode
        
        /* Setup button selection handler */
        buttonRestart.selectedHandler = { [unowned self] in
            
            if let view = self.view {
                
                // Load the SKScene from 'GameScene.sks'
                if let scene = SKScene(fileNamed: "GameScene") {
                    
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view.presentScene(scene)
                }
                
                // Debug helpers
                view.showsFPS = true
                view.showsPhysics = true
                view.showsDrawCount = true
            }
        }
        
        /* Initialize catapult arm physics body of type alpha */
        let catapultArmBody = SKPhysicsBody (texture: catapultArm!.texture!, size: catapultArm.size)
        
        /* Mass needs to be heavy enough to hit the penguin with sufficient force */
        catapultArmBody.mass = 0.5
        
        /* No need for gravity otherwise the arm will fall over */
        catapultArmBody.affectedByGravity = false
        
        /* Improves physics collision handling of fast moving objects */
        catapultArmBody.usesPreciseCollisionDetection = true
        
        /* Assign the physics body to the catapult arm */
        catapultArm.physicsBody = catapultArmBody
        
        /* Pin joint catapult and catapult arm */
        let catapultPinJoint = SKPhysicsJointPin.joint(withBodyA: catapult.physicsBody!, bodyB: catapultArm.physicsBody!, anchor: CGPoint(x:-81.453 ,y:-51.159))
        physicsWorld.add(catapultPinJoint)
        
        /* Spring joint catapult arm and cantilever node */
        let catapultSpringJoint = SKPhysicsJointSpring.joint(withBodyA: catapultArm.physicsBody!, bodyB: cantileverNode.physicsBody!, anchorA: catapultArm.position + CGPoint(x:15, y:30), anchorB: cantileverNode.position)
        physicsWorld.add(catapultSpringJoint)
        
        /* Make this joint a bit more springy */
        catapultSpringJoint.frequency = 1.5
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        /* There will only be one touch as multi touch is not enabled by default */
        for touch in touches {
            
            /* Grab scene position of touch */
            let location    = touch.location(in: self)
            
            /* Get node reference if we're touching a node */
            let touchedNode = atPoint(location)
            
            /* Is it the catapult arm? */
            if touchedNode.name == "catapultArm" {
                
                /* Reset touch node position */
                touchNode.position = location
                
                /* Spring joint touch node and catapult arm */
                touchJoint = SKPhysicsJointSpring.joint(withBodyA: touchNode.physicsBody!, bodyB: catapultArm.physicsBody!, anchorA: location, anchorB: location)
                physicsWorld.add(touchJoint!)
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch moved */
        
        /* There will only be one touch as multi touch is not enabled by default */
        for touch in touches {
            
            /* Grab scene position of touch and update touchNode position */
            let location       = touch.location(in: self)
            touchNode.position = location
            
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch ended */
        
        /* Let it fly!, remove joints used in catapult launch */
        if let touchJoint = touchJoint {
            physicsWorld.remove(touchJoint)
        }
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


