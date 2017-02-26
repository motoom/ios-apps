
import GameplayKit

class GameState: GKState {
    let controller: GameController

    init(controller: GameController) {
        self.controller = controller
        }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        print("GameState.updateWithDeltaTime(\(seconds))")
        }
    }

