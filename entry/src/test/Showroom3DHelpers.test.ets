import { describe, it, expect } from '@ohos/hypium'
import {
  SHOWROOM_DEFAULT_DISTANCE,
  SHOWROOM_DEFAULT_PITCH,
  SHOWROOM_MAX_DISTANCE,
  SHOWROOM_MIN_PITCH,
  SHOWROOM_MIN_DISTANCE,
  buildCameraEye,
  clampShowroomDistance,
  deriveDistanceFromPinch,
  derivePitchFromPan,
  deriveYawFromPan
} from '../main/ets/common/showroom/Showroom3DHelpers'

export default function showroom3DHelpersTest() {
  describe('showroom3DHelpersTest', () => {
    it('clamps showroom distance inside native viewer bounds', 0, () => {
      expect(clampShowroomDistance(SHOWROOM_MIN_DISTANCE - 1)).assertEqual(SHOWROOM_MIN_DISTANCE)
      expect(clampShowroomDistance(SHOWROOM_MAX_DISTANCE + 1)).assertEqual(SHOWROOM_MAX_DISTANCE)
    })

    it('derives a new yaw from horizontal pan offset', 0, () => {
      const yaw = deriveYawFromPan(0.5, 120)
      expect(Number(yaw.toFixed(2))).assertEqual(-0.70)
    })

    it('clamps pitch and zooms with pinch scale for orbit viewing', 0, () => {
      const pitch = derivePitchFromPan(SHOWROOM_DEFAULT_PITCH, -200)
      const distance = deriveDistanceFromPinch(SHOWROOM_DEFAULT_DISTANCE, 2)

      expect(Number(pitch.toFixed(2))).assertEqual(SHOWROOM_MIN_PITCH)
      expect(distance).assertEqual(SHOWROOM_MIN_DISTANCE)
    })

    it('builds the orbit camera eye from yaw pitch and distance', 0, () => {
      const cameraEye = buildCameraEye(SHOWROOM_DEFAULT_DISTANCE, 0, SHOWROOM_DEFAULT_PITCH)

      expect(Number(cameraEye.x.toFixed(1))).assertEqual(0.0)
      expect(Number(cameraEye.y.toFixed(1))).assertEqual(0.3)
      expect(Number(cameraEye.z.toFixed(1))).assertEqual(-2.4)
    })
  })
}
