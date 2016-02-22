
import GameplayKit

class GameState: GKState {
    let controller: GameController

    init(controller: GameController) {
        self.controller = controller
        }

    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        super.updateWithDeltaTime(seconds)
        print("GameState.updateWithDeltaTime(\(seconds))")
        }
    }

