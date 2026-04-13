import { BusinessError } from '@kit.BasicServicesKit'
import type { Camera, Light, Node, Quaternion, Vec3 } from '@kit.ArkGraphics3D'
import { LightType, Scene } from '@kit.ArkGraphics3D'
import { AppColors, AppSizes } from '../common/constants/AppConstants'
import { SHOWROOM_EXHIBIT } from '../common/showroom/ShowroomData'
import {
  SHOWROOM_AUTO_ROTATE_STEP,
  SHOWROOM_DEFAULT_DISTANCE,
  buildCameraEye,
  buildYawQuaternion,
  deriveDistanceFromPinch,
  deriveYawFromPan
} from '../common/showroom/Showroom3DHelpers'

@Component
export struct ShowroomPage {
  private showroomScene?: Scene
  private showroomAssetScene?: Scene
  private showroomModel: Node | null = null
  private showroomCamera: Camera | null = null
  private autoRotateTimer: number = -1
  private orbitYaw: number = -0.52
  private orbitDistance: number = SHOWROOM_DEFAULT_DISTANCE
  private panStartYaw: number = this.orbitYaw
  private pinchStartDistance: number = this.orbitDistance
  private isInteracting: boolean = false

  @State private isLoading: boolean = true
  @State private hasError: boolean = false
  @State private errorMessage: string = '展品加载失败，请稍后重试'
  @State private sceneReady: boolean = false

  aboutToAppear(): void {
    this.startAutoRotate()
    this.ensureNativeScene()
  }

  aboutToDisappear(): void {
    this.stopAutoRotate()
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
    this.errorMessage = '展品加载失败，请稍后重试'

    try {
      const containerScene: Scene = await Scene.load()
      const assetScene: Scene = await Scene.load($rawfile('showroom/models/aurora_x_showcar.gltf'))
      const showroomModel: Node = containerScene.importScene('AuroraShowCar', assetScene, null)
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
      showroomCamera.fov = 34
      showroomCamera.nearPlane = 0.1
      showroomCamera.farPlane = 40

      keyLight.enabled = true
      keyLight.color = { r: 1, g: 0.97, b: 0.92, a: 1 }
      keyLight.intensity = 180000
      keyLight.shadowEnabled = false

      fillLight.enabled = true
      fillLight.color = { r: 0.62, g: 0.76, b: 1, a: 1 }
      fillLight.intensity = 60000
      fillLight.shadowEnabled = false

      this.applyLookAt(keyLight, { x: -3.5, y: 4.2, z: -4.8 }, { x: 0, y: 0.05, z: 0 }, { x: 0, y: 1, z: 0 })
      this.applyLookAt(fillLight, { x: 4.2, y: 2.6, z: 3.2 }, { x: 0, y: 0.1, z: 0 }, { x: 0, y: 1, z: 0 })

      showroomModel.scale = { x: 1.08, y: 1.08, z: 1.08 }
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
        ? `原生 3D 展品加载失败：${detail}`
        : '原生 3D 展品加载失败，请在鸿蒙模拟器或真机查看效果'
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

  private startAutoRotate(): void {
    if (this.autoRotateTimer >= 0) {
      return
    }

    this.autoRotateTimer = setInterval(() => {
      if (this.isInteracting || this.isLoading || this.hasError || !this.sceneReady) {
        return
      }

      this.orbitYaw += SHOWROOM_AUTO_ROTATE_STEP
      this.applyOrbitToScene()
    }, 42)
  }

  private stopAutoRotate(): void {
    if (this.autoRotateTimer >= 0) {
      clearInterval(this.autoRotateTimer)
      this.autoRotateTimer = -1
    }
  }

  private applyOrbitToScene(): void {
    if (!this.showroomScene || !this.showroomModel || !this.showroomCamera) {
      return
    }

    this.showroomModel.rotation = buildYawQuaternion(this.orbitYaw)
    this.applyLookAt(this.showroomCamera, buildCameraEye(this.orbitDistance), { x: 0, y: 0.08, z: 0 }, {
      x: 0,
      y: 1,
      z: 0
    })
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

            Text('原生 ArkGraphics3D 车模展示页，这次不再走 Web 3D。')
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
                  this.TagChip('Aurora X')
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
                          this.isInteracting = true
                          this.panStartYaw = this.orbitYaw
                        })
                        .onActionUpdate((event: GestureEvent) => {
                          this.orbitYaw = deriveYawFromPan(this.panStartYaw, event.offsetX)
                          this.applyOrbitToScene()
                        })
                        .onActionEnd(() => {
                          this.isInteracting = false
                        })
                        .onActionCancel(() => {
                          this.isInteracting = false
                        }),
                      PinchGesture({ fingers: 2 })
                        .onActionStart(() => {
                          this.isInteracting = true
                          this.pinchStartDistance = this.orbitDistance
                        })
                        .onActionUpdate((event: GestureEvent) => {
                          this.orbitDistance = deriveDistanceFromPinch(this.pinchStartDistance, event.scale)
                          this.applyOrbitToScene()
                        })
                        .onActionEnd(() => {
                          this.isInteracting = false
                        })
                        .onActionCancel(() => {
                          this.isInteracting = false
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
                Text('正在准备原生 3D 展品...')
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
                Text('展品暂时不可用')
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
