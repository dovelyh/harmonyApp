import { describe, it, expect } from '@ohos/hypium'
import {
  SHOWROOM_CAMERA_HEIGHT,
  SHOWROOM_DEFAULT_DISTANCE,
  SHOWROOM_MAX_DISTANCE,
  SHOWROOM_MIN_DISTANCE,
  buildCameraEye,
  buildYawQuaternion,
  clampShowroomDistance,
  deriveDistanceFromPinch,
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
      expect(Number(yaw.toFixed(2))).assertEqual(1.70)
    })

    it('zooms with pinch scale and exposes camera and rotation helpers', 0, () => {
      const distance = deriveDistanceFromPinch(SHOWROOM_DEFAULT_DISTANCE, 2)
      const cameraEye = buildCameraEye(distance)
      const rotation = buildYawQuaternion(Math.PI)

      expect(distance).assertEqual(SHOWROOM_MIN_DISTANCE)
      expect(Number(cameraEye.y.toFixed(1))).assertEqual(SHOWROOM_CAMERA_HEIGHT)
      expect(Number(rotation.y.toFixed(2))).assertEqual(1.00)
      expect(Number(rotation.w.toFixed(2))).assertEqual(0.00)
    })
  })
}
