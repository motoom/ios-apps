
//  Interpolation.swift

func lerp1d(low: Double, _ high: Double, _ pos: Double) -> Double
{
	return low + (high - low) * pos
}

func lerp2d(fromX: Double, _ fromY: Double, _ toX: Double, _ toY: Double, _ x: Double) -> Double
{
	let dy = toY - fromY
	let dx = toX - fromX
	if dx == 0 {
        return fromY + (toY - fromY) / 2
        }
	if dy==0 {
        return fromY
        }
	let slope = dy / dx
	return slope * (x - fromX) + fromY
}
