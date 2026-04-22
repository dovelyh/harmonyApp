import { BusinessError } from '@kit.BasicServicesKit'
import type { Camera, Light, Node, Quaternion, Vec3 } from '@kit.ArkGraphics3D'
import { LightType, Scene } from '@kit.ArkGraphics3D'
import { AppColors, AppSizes } from '../common/constants/AppConstants'
import { SHOWROOM_EXHIBIT } from '../common/showroom/ShowroomData'
import {
  SHOWROOM_CAMERA_TARGET,
  SHOWROOM_DEFAULT_DISTANCE,
  SHOWROOM_DEFAULT_PITCH,
  buildCameraEye,
  deriveDistanceFromPinch,
  derivePitchFromPan,
  deriveYawFromPan
} from '../common/showroom/Showroom3DHelpers'

const SHOWROOM_MODEL_SCALE: number = 1.18
const SHOWROOM_MODEL_TILT_RADIANS: number = -Math.PI / 2

@Component
export struct ShowroomPage {
  private showroomScene?: Scene
  private showroomAssetScene?: Scene
  private showroomModel: Node | null = null
  private showroomCamera: Camera | null = null
  private orbitYaw: number = 0.28
  private orbitPitch: number = SHOWROOM_DEFAULT_PITCH
  private orbitDistance: number = SHOWROOM_DEFAULT_DISTANCE
  private panStartYaw: number = this.orbitYaw
  private panStartPitch: number = this.orbitPitch
  private pinchStartDistance: number = this.orbitDistance

  @State private isLoading: boolean = true
  @State private hasError: boolean = false
  @State private errorMessage: string = '人物模型加载失败，请稍后重试'
  @State private sceneReady: boolean = false

  aboutToAppear(): void {
    this.ensureNativeScene()
  }

  private async ensureNativeScene(): Promise<void> {
    if (this.showroomScene) {
      this.sceneReady = true
      this.isLoading = false
      this.applyOrbitToScene()
      return
    }

    this.isLoading = true
    this.hasError = false
    this.errorMessage = '人物模型加载失败，请稍后重试'

    try {
      const containerScene: Scene = await Scene.load()
      const assetScene: Scene = await Scene.load($rawfile('showroom/models/dog_ziwen.glb'))
      const showroomModel: Node = containerScene.importScene('DogZiwen', assetScene, null)
      const sceneFactory = containerScene.getResourceFactory()
      const showroomCamera: Camera = await sceneFactory.createCamera({
        name: 'showroomCamera',
        path: '//showroomCamera'
      })
      const keyLight: Light = await sceneFactory.createLight({
        name: 'showroomKeyLight',
        path: '//showroomKeyLight'
      }, LightType.DIRECTIONAL)
      const fillLight: Light = await sceneFactory.createLight({
        name: 'showroomFillLight',
        path: '//showroomFillLight'
      }, LightType.DIRECTIONAL)

      showroomCamera.enabled = true
      showroomCamera.fov = 28
      showroomCamera.nearPlane = 0.1
      showroomCamera.farPlane = 40

      keyLight.enabled = true
      keyLight.color = { r: 1, g: 0.96, b: 0.91, a: 1 }
      keyLight.intensity = 165000
      keyLight.shadowEnabled = false

      fillLight.enabled = true
      fillLight.color = { r: 0.58, g: 0.76, b: 1, a: 1 }
      fillLight.intensity = 70000
      fillLight.shadowEnabled = false

      this.applyLookAt(keyLight, { x: -3.6, y: 4.6, z: -4.9 }, SHOWROOM_CAMERA_TARGET, { x: 0, y: 1, z: 0 })
      this.applyLookAt(fillLight, { x: 4.1, y: 2.4, z: 3.6 }, { x: 0, y: 0.4, z: 0 }, { x: 0, y: 1, z: 0 })

      showroomModel.rotation = this.quaternionFromAxisAngle({ x: 1, y: 0, z: 0 }, SHOWROOM_MODEL_TILT_RADIANS)
      showroomModel.scale = { x: SHOWROOM_MODEL_SCALE, y: SHOWROOM_MODEL_SCALE, z: SHOWROOM_MODEL_SCALE }
      this.showroomScene = containerScene
      this.showroomAssetScene = assetScene
      this.showroomModel = showroomModel
      this.showroomCamera = showroomCamera
      this.applyOrbitToScene()

      this.sceneReady = true
      this.isLoading = false
      this.hasError = false
    } catch (error) {
      this.destroyNativeScene()

      const businessError = error as BusinessError
      const detail: string = businessError?.message ? businessError.message : `${error}`
      this.errorMessage = detail.length > 0
        ? `原生 3D 人物模型加载失败：${detail}`
        : '原生 3D 人物模型加载失败，请在鸿蒙模拟器或真机查看效果'
      this.hasError = true
      this.isLoading = false
      this.sceneReady = false
    }
  }

  private reloadViewer(): void {
    this.destroyNativeScene()
    this.ensureNativeScene()
  }

  private destroyNativeScene(): void {
    if (this.showroomScene) {
      this.showroomScene.destroy()
    }
    if (this.showroomAssetScene) {
      this.showroomAssetScene.destroy()
    }

    this.showroomScene = undefined
    this.showroomAssetScene = undefined
    this.showroomModel = null
    this.showroomCamera = null
    this.sceneReady = false
  }

  private applyOrbitToScene(): void {
    if (!this.showroomScene || !this.showroomModel || !this.showroomCamera) {
      return
    }

    this.applyLookAt(
      this.showroomCamera,
      buildCameraEye(this.orbitDistance, this.orbitYaw, this.orbitPitch, SHOWROOM_CAMERA_TARGET),
      SHOWROOM_CAMERA_TARGET,
      {
        x: 0,
        y: 1,
        z: 0
      }
    )
    this.showroomScene.renderFrame({ alwaysRender: true })
  }

  private applyLookAt(node: Node, eye: Vec3, center: Vec3, up: Vec3): void {
    const forward: Vec3 = this.normalizeVec3(this.subtractVec3(center, eye))
    const right: Vec3 = this.normalizeVec3(this.crossVec3(forward, up))
    const upward: Vec3 = this.crossVec3(right, forward)
    const backward: Vec3 = { x: -forward.x, y: -forward.y, z: -forward.z }

    let scalar: number
    let quaternion: Quaternion = { x: 0, y: 0, z: 0, w: 0 }

    if (backward.z < 0) {
      if (right.x > upward.y) {
        scalar = 1 + right.x - upward.y - backward.z
        quaternion = {
          x: scalar,
          y: right.y + upward.x,
          z: backward.x + right.z,
          w: upward.z - backward.y
        }
      } else {
        scalar = 1 - right.x + upward.y - backward.z
        quaternion = {
          x: right.y + upward.x,
          y: scalar,
          z: upward.z + backward.y,
          w: backward.x - right.z
        }
      }
    } else if (right.x < -upward.y) {
      scalar = 1 - right.x - upward.y + backward.z
      quaternion = {
        x: backward.x + right.z,
        y: upward.z + backward.y,
        z: scalar,
        w: right.y - upward.x
      }
    } else {
      scalar = 1 + right.x + upward.y + backward.z
      quaternion = {
        x: upward.z - backward.y,
        y: backward.x - right.z,
        z: right.y - upward.x,
        w: scalar
      }
    }

    node.position = eye
    node.rotation = this.scaleQuaternion(quaternion, 0.5 / Math.sqrt(scalar))
  }

  private subtractVec3(left: Vec3, right: Vec3): Vec3 {
    return {
      x: left.x - right.x,
      y: left.y - right.y,
      z: left.z - right.z
    }
  }

  private dotVec3(left: Vec3, right: Vec3): number {
    return left.x * right.x + left.y * right.y + left.z * right.z
  }

  private normalizeVec3(value: Vec3): Vec3 {
    const length: number = Math.sqrt(this.dotVec3(value, value))
    if (length < 0.00001) {
      return {
        x: 0,
        y: 0,
        z: 0
      }
    }

    return {
      x: value.x / length,
      y: value.y / length,
      z: value.z / length
    }
  }

  private crossVec3(left: Vec3, right: Vec3): Vec3 {
    return {
      x: left.y * right.z - left.z * right.y,
      y: left.z * right.x - left.x * right.z,
      z: left.x * right.y - left.y * right.x
    }
  }

  private scaleQuaternion(value: Quaternion, scalar: number): Quaternion {
    return {
      x: value.x * scalar,
      y: value.y * scalar,
      z: value.z * scalar,
      w: value.w * scalar
    }
  }

  private quaternionFromAxisAngle(axis: Vec3, angle: number): Quaternion {
    const normalizedAxis: Vec3 = this.normalizeVec3(axis)
    const halfAngle: number = angle * 0.5
    const sine: number = Math.sin(halfAngle)
    return {
      x: normalizedAxis.x * sine,
      y: normalizedAxis.y * sine,
      z: normalizedAxis.z * sine,
      w: Math.cos(halfAngle)
    }
  }

  @Builder
  private TagChip(label: string) {
    Text(label)
      .fontSize(12)
      .fontColor('#FFE4D8')
      .padding({ left: 12, right: 12, top: 6, bottom: 6 })
      .backgroundColor('#FFFFFF12')
      .border({ width: 1, color: '#FFFFFF1A' })
      .borderRadius(999)
      .margin({ right: 8, bottom: 8 })
  }

  build() {
    Scroll() {
      Column({ space: 16 }) {
        Row() {
          Column({ space: 4 }) {
            Text('展馆')
              .fontSize(24)
              .fontWeight(FontWeight.Bold)
              .fontColor(AppColors.TextPrimary)

            Text('原生 ArkGraphics3D 人物模型展示，支持上下左右和远近拖拽查看。')
              .fontSize(13)
              .fontColor(AppColors.TextSecondary)
          }
          .alignItems(HorizontalAlign.Start)

          Blank()

          Text('Native 3D')
            .fontSize(12)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FFFFFF')
            .padding({ left: 10, right: 10, top: 6, bottom: 6 })
            .backgroundColor(AppColors.Primary)
            .borderRadius(999)
        }
        .width('100%')

        Column({ space: 10 }) {
          Stack({ alignContent: Alignment.Center }) {
            Stack({ alignContent: Alignment.TopStart }) {
              Column()
                .width('100%')
                .height('100%')
                .backgroundColor('#07111E')

              Column({ space: 8 }) {
                Row({ space: 8 }) {
                  this.TagChip('Simple Figure')
                  this.TagChip('ArkGraphics3D')
                }
              }
              .padding({ left: 16, top: 16 })

              if (this.sceneReady && this.showroomScene) {
                Component3D({ scene: this.showroomScene, modelType: ModelType.SURFACE })
                  .width('100%')
                  .height('100%')
                  .renderWidth('100%')
                  .renderHeight('100%')
                  .gesture(
                    GestureGroup(
                      GestureMode.Parallel,
                      PanGesture({ distance: 1 })
                        .onActionStart(() => {
                          this.panStartYaw = this.orbitYaw
                          this.panStartPitch = this.orbitPitch
                        })
                        .onActionUpdate((event: GestureEvent) => {
                          this.orbitYaw = deriveYawFromPan(this.panStartYaw, event.offsetX)
                          this.orbitPitch = derivePitchFromPan(this.panStartPitch, event.offsetY)
                          this.applyOrbitToScene()
                        }),
                      PinchGesture({ fingers: 2 })
                        .onActionStart(() => {
                          this.pinchStartDistance = this.orbitDistance
                        })
                        .onActionUpdate((event: GestureEvent) => {
                          this.orbitDistance = deriveDistanceFromPinch(this.pinchStartDistance, event.scale)
                          this.applyOrbitToScene()
                        })
                    )
                  )
              }
            }
            .width('100%')
            .height('100%')

            if (this.isLoading && !this.hasError) {
              Column({ space: 10 }) {
                LoadingProgress().color(AppColors.Primary)
                Text('正在准备人物模型...')
                  .fontSize(13)
                  .fontColor('#E6EDF8')
              }
              .width(208)
              .padding({ top: 18, bottom: 18 })
              .backgroundColor('#0F1728D8')
              .borderRadius(20)
            }

            if (this.hasError) {
              Column({ space: 12 }) {
                Text('人物模型暂时不可用')
                  .fontSize(18)
                  .fontWeight(FontWeight.Bold)
                  .fontColor('#FFFFFF')

                Text(this.errorMessage)
                  .fontSize(13)
                  .fontColor('#C9D3E7')
                  .textAlign(TextAlign.Center)

                Button('重新加载')
                  .height(40)
                  .backgroundColor(AppColors.Primary)
                  .borderRadius(20)
                  .onClick(() => this.reloadViewer())
              }
              .width('84%')
              .padding(20)
              .backgroundColor('#0F1728EE')
              .borderRadius(20)
            }
          }
          .width('100%')
          .height(360)
          .borderRadius(28)
          .clip(true)
          .shadow({ radius: 28, color: '#16233835', offsetX: 0, offsetY: 14 })

          Row({ space: 8 }) {
            Text('运行提示')
              .fontSize(12)
              .fontWeight(FontWeight.Medium)
              .fontColor(AppColors.Primary)

            Text(SHOWROOM_EXHIBIT.runtimeHint)
              .fontSize(12)
              .fontColor(AppColors.TextSecondary)
          }
          .width('100%')
        }
        .width('100%')

        Column({ space: 14 }) {
          Text(SHOWROOM_EXHIBIT.title)
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor(AppColors.TextPrimary)

          Text(SHOWROOM_EXHIBIT.subtitle)
            .fontSize(13)
            .fontColor(AppColors.TextSecondary)

          Flex({ wrap: FlexWrap.Wrap }) {
            ForEach(SHOWROOM_EXHIBIT.tags, (tag: string) => {
              Text(tag)
                .fontSize(12)
                .fontColor(AppColors.Primary)
                .padding({ left: 12, right: 12, top: 6, bottom: 6 })
                .backgroundColor(AppColors.PrimaryLight)
                .borderRadius(999)
                .margin({ right: 8, bottom: 8 })
            })
          }
          .width('100%')

          Text(SHOWROOM_EXHIBIT.description)
            .fontSize(14)
            .fontColor(AppColors.TextSecondary)
            .lineHeight(22)
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .padding(18)
        .backgroundColor(AppColors.CardBg)
        .borderRadius(AppSizes.CardRadius)

        Row({ space: 10 }) {
          Text('操作提示')
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .fontColor(AppColors.Primary)

          Text(SHOWROOM_EXHIBIT.gestureHint)
            .fontSize(12)
            .fontColor(AppColors.TextSecondary)
        }
        .width('100%')
        .padding({ left: 14, right: 14, top: 12, bottom: 12 })
        .backgroundColor('#FFF6F1')
        .borderRadius(AppSizes.CardRadius)
      }
      .width('100%')
      .alignItems(HorizontalAlign.Start)
      .padding({ left: 16, right: 16, top: 14, bottom: 24 })
    }
    .scrollBar(BarState.Off)
    .width('100%')
    .height('100%')
    .backgroundColor(AppColors.Background)
  }
}
