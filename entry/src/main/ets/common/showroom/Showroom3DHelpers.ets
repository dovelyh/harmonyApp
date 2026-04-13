import type { Quaternion, Vec3 } from '@kit.ArkGraphics3D'

export const SHOWROOM_MIN_DISTANCE: number = 2.4
export const SHOWROOM_MAX_DISTANCE: number = 5.8
export const SHOWROOM_DEFAULT_DISTANCE: number = 3.8
export const SHOWROOM_CAMERA_HEIGHT: number = 0.9
export const SHOWROOM_ROTATION_SENSITIVITY: number = 0.01
export const SHOWROOM_AUTO_ROTATE_STEP: number = 0.012

export function clampShowroomDistance(distance: number): number {
  return Math.max(SHOWROOM_MIN_DISTANCE, Math.min(SHOWROOM_MAX_DISTANCE, distance))
}

export function deriveYawFromPan(startYaw: number, offsetX: number): number {
  return startYaw + offsetX * SHOWROOM_ROTATION_SENSITIVITY
}

export function deriveDistanceFromPinch(startDistance: number, scale: number): number {
  const safeScale: number = scale > 0.001 ? scale : 1
  return clampShowroomDistance(startDistance / safeScale)
}

export function buildYawQuaternion(yaw: number): Quaternion {
  const halfYaw: number = yaw / 2
  return {
    x: 0,
    y: Math.sin(halfYaw),
    z: 0,
    w: Math.cos(halfYaw)
  }
}

export function buildCameraEye(distance: number): Vec3 {
  return {
    x: 0,
    y: SHOWROOM_CAMERA_HEIGHT,
    z: -clampShowroomDistance(distance)
  }
}
