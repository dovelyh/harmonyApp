import type { Vec3 } from '@kit.ArkGraphics3D'

export const SHOWROOM_MIN_DISTANCE: number = 1.7
export const SHOWROOM_MAX_DISTANCE: number = 5.0
export const SHOWROOM_DEFAULT_DISTANCE: number = 2.45
export const SHOWROOM_MIN_PITCH: number = -0.32
export const SHOWROOM_MAX_PITCH: number = 0.78
export const SHOWROOM_DEFAULT_PITCH: number = 0.08
export const SHOWROOM_ROTATION_SENSITIVITY: number = 0.01
export const SHOWROOM_PITCH_SENSITIVITY: number = 0.008
export const SHOWROOM_CAMERA_TARGET: Vec3 = { x: 0, y: 0.08, z: 0 }

export function clampShowroomDistance(distance: number): number {
  return Math.max(SHOWROOM_MIN_DISTANCE, Math.min(SHOWROOM_MAX_DISTANCE, distance))
}

export function clampShowroomPitch(pitch: number): number {
  return Math.max(SHOWROOM_MIN_PITCH, Math.min(SHOWROOM_MAX_PITCH, pitch))
}

export function deriveYawFromPan(startYaw: number, offsetX: number): number {
  return startYaw - offsetX * SHOWROOM_ROTATION_SENSITIVITY
}

export function derivePitchFromPan(startPitch: number, offsetY: number): number {
  return clampShowroomPitch(startPitch + offsetY * SHOWROOM_PITCH_SENSITIVITY)
}

export function deriveDistanceFromPinch(startDistance: number, scale: number): number {
  const safeScale: number = scale > 0.001 ? scale : 1
  return clampShowroomDistance(startDistance / safeScale)
}

export function buildCameraEye(distance: number, yaw: number, pitch: number, target: Vec3 = SHOWROOM_CAMERA_TARGET): Vec3 {
  const clampedDistance: number = clampShowroomDistance(distance)
  const clampedPitch: number = clampShowroomPitch(pitch)
  const horizontalDistance: number = clampedDistance * Math.cos(clampedPitch)
  return {
    x: target.x + Math.sin(yaw) * horizontalDistance,
    y: target.y + Math.sin(clampedPitch) * clampedDistance,
    z: target.z - Math.cos(yaw) * horizontalDistance
  }
}
