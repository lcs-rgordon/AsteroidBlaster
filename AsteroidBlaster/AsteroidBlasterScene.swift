import Foundation
import ImagineEngine

class AsteroidBlasterScene : Scene {
    
    override func setup() {
        
        // Set the background colour
        backgroundColor = Color(red: 0, green: 0, blue: 0.3, alpha: 1)
        
        // Create the ground
        let groundSize = Size(width: size.width, height: 100)
        let ground = Block(size: groundSize, textureCollectionName: "Ground", textureScale: 2)
        
        // Position ground at bottom of scene
        ground.position.x = center.x
        ground.position.y = size.height - groundSize.height / 2
        
        // Make a group for the ground to create events on
        let groundGroup = Group.name("Ground")
        ground.group = groundGroup
        
        // Add ground to the scene
        self.add(ground)
        
        // Create a row of houses to protect
        let housesGroup = Group.name("Houses")
        for x in stride(from: center.x - 100, to: center.x + 150, by: 50) {
            
            // Create the house and add to scene
            let house = Actor()
            house.group = housesGroup
            house.animation = Animation(name: "House", frameCount: 1, frameDuration: 0)
            house.animation!.textureScale = 2
            self.add(house)
            
            // Set the house's positions
            house.position.x = x
            house.position.y = ground.rect.minY - house.size.height / 2
        }
        
        // Repeatedly add an asteroid to this scene
        timeline.repeat(withInterval: 2, using: self) { scene in
            
            // Create the asteroid
            let asteroid = Actor()
            asteroid.animation = Animation(name: "Asteroid", frameCount: 1, frameDuration: 0)
            asteroid.animation!.textureScale = 2
            
            // Position the asteroid
            let positionRange = scene.size.width - asteroid.size.width
            let randomPosition = Metric(arc4random_uniform(UInt32(positionRange)))
            asteroid.position.x = asteroid.size.width / 2 + randomPosition
            
            // Make the asteroid move downward on the screen
            asteroid.velocity.dy = 100
            
            // Detect collisions with ground
            asteroid.events.collided(withBlockInGroup: groundGroup).observe { asteroid in
                
                asteroid.explode()
                
            }
            
            // Detect collisions with a house
            asteroid.events.collided(withActorInGroup: housesGroup).observe { asteroid, house in
                
                // Asteroid explodes
                asteroid.explode()
                
                // House explodes
                house.explode().then {
                    
                    // Iterate over all actors in the scene
                    // If a house is found, stop
                    for actor in scene.actors {
                        if actor.group == housesGroup {
                            return
                        }
                    }
                    
                    // No houses found, so restart the scene and the game
                    scene.reset()
                }
                
            }
            
            // Can now click to destroy an asteroid
            asteroid.events.clicked.observe { asteroid in
                asteroid.explode()
                print("registered click")
            }
            
            // Add the asteroid to the scene
            scene.add(asteroid)
            
        }
        
        
    }
    
}

extension Actor {
    @discardableResult func explode() -> ActionToken {
        
        // Stop the actor
        velocity = .zero
        
        // Define the animation
        var explosionAnimation = Animation(
            name: "Explosion",
            frameCount: 7,
            frameDuration: 0.07,
            repeatMode: .never
        )
        explosionAnimation.textureScale = 2
        
        return playAnimation(explosionAnimation).then {
            self.remove()   // Actor removes itself from the scene
        }
    }
}

