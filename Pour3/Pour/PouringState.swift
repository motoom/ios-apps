
// Animate the pouring from source to destination

import GameplayKit

class PouringState: GameState {
    override init(controller: GameController) {
        super.init(controller: controller)
        }

    override func didEnter(from prevState: GKState?) {
        super.didEnter(from: prevState)
        print("Entered Pouring from \(prevState)")
    }

    override func update(deltaTime seconds: TimeInterval) {
        print("PouringState.updateWithDeltaTime(\(seconds))")
        super.update(deltaTime: seconds)
        // TODO: Depending on whether puzzle is solved:
        if arc4random_uniform(100) > 80 {
            self.stateMachine?.enter(SolvedState.self)
            }
        else {
            self.stateMachine?.enter(SelectingState.self)
            }
        }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is SelectingState.Type || stateClass is SolvedState.Type
        }

    }



