# Harmony Native Showroom 3D Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the current Web-based showroom viewer with a native HarmonyOS `ArkGraphics3D + Component3D` car showcase page that supports auto-rotation, drag rotation, and pinch zoom.

**Architecture:** Keep the existing `展馆` tab and page shell, but swap the `Web` component for `Component3D`. Load a local glTF car scene into a native `Scene`, manage orbit state with small pure helpers under `common/showroom/`, and keep a graceful message that Previewer cannot represent the real 3D effect. Remove the old Web viewer runtime resources once the native path is live.

**Tech Stack:** HarmonyOS 6.0.2 (API 22), ArkTS, ArkUI declarative UI, ArkGraphics3D, Hypium unit tests, hvigor build.

---

### Task 1: Add showroom orbit helpers and test them first

**Files:**
- Create: `entry/src/main/ets/common/showroom/Showroom3DHelpers.ets`
- Create: `entry/src/test/Showroom3DHelpers.test.ets`
- Modify: `entry/src/test/List.test.ets`

- [ ] **Step 1: Write the failing helper test**

```ts
import {
  clampShowroomDistance,
  deriveDistanceFromPinch,
  deriveYawFromPan
} from '../main/ets/common/showroom/Showroom3DHelpers'
```

- [ ] **Step 2: Run test to verify it fails**

Run: `DEVECO_SDK_HOME=/Applications/DevEco-Studio.app/Contents/sdk node /Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw.js --mode module -p module=entry@default -p product=default test`

Expected: unit test compile fails because the showroom helper module does not exist yet.

- [ ] **Step 3: Write the minimal helper implementation**

```ts
export function clampShowroomDistance(distance: number): number {
  return Math.max(SHOWROOM_MIN_DISTANCE, Math.min(SHOWROOM_MAX_DISTANCE, distance))
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `DEVECO_SDK_HOME=/Applications/DevEco-Studio.app/Contents/sdk node /Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw.js --mode module -p module=entry@default -p product=default test`

Expected: showroom helper tests pass.

- [ ] **Step 5: Commit**

```bash
git add entry/src/main/ets/common/showroom/Showroom3DHelpers.ets entry/src/test/Showroom3DHelpers.test.ets entry/src/test/List.test.ets
git commit -m "test: cover native showroom orbit helpers"
```

### Task 2: Add the native 3D car model resource and update showroom copy

**Files:**
- Create: `entry/src/main/resources/rawfile/showroom/models/aurora_x_showcar.gltf`
- Modify: `entry/src/main/ets/common/showroom/ShowroomData.ets`

- [ ] **Step 1: Add a local glTF showroom car asset**

```json
{
  "asset": { "version": "2.0" }
}
```

- [ ] **Step 2: Update exhibit text for native ArkGraphics3D rendering**

```ts
subtitle: 'ArkGraphics3D 原生 3D 展品'
```

- [ ] **Step 3: Verify the resource path is ready for Component3D**

Run: `rg -n "AuroraShowCar|ArkGraphics3D 原生 3D 展品" entry/src/main/resources/rawfile/showroom/models/aurora_x_showcar.gltf entry/src/main/ets/common/showroom/ShowroomData.ets`

Expected: both the model file and native showroom copy are present.

- [ ] **Step 4: Commit**

```bash
git add entry/src/main/resources/rawfile/showroom/models/aurora_x_showcar.gltf entry/src/main/ets/common/showroom/ShowroomData.ets
git commit -m "feat: add native showroom model asset"
```

### Task 3: Replace the showroom page with a native Component3D viewer

**Files:**
- Modify: `entry/src/main/ets/pages/ShowroomPage.ets`
- Delete: `entry/src/main/resources/rawfile/showroom/index.html`
- Delete: `entry/src/main/resources/rawfile/showroom/styles.css`
- Delete: `entry/src/main/resources/rawfile/showroom/app.js`
- Delete: `entry/src/main/resources/rawfile/showroom/lib/three.min.js`
- Delete: `entry/src/main/resources/rawfile/showroom/lib/OrbitControls.js`

- [ ] **Step 1: Load a native Scene and import the glTF model**

```ts
const containerScene = await Scene.load()
const modelScene = await Scene.load($rawfile('showroom/models/aurora_x_showcar.gltf'))
this.showroomModel = containerScene.importScene('AuroraShowCar', modelScene, null)
```

- [ ] **Step 2: Create camera/orbit behavior and wire drag and pinch gestures**

```ts
this.orbitYaw = deriveYawFromPan(this.panStartYaw, event.offsetX)
this.orbitDistance = deriveDistanceFromPinch(this.pinchStartDistance, event.scale)
```

- [ ] **Step 3: Render `Component3D` inside the existing showroom card**

```ts
Component3D({ scene: this.showroomScene, modelType: ModelType.SURFACE })
```

- [ ] **Step 4: Remove the unused Web viewer assets**

```bash
git rm entry/src/main/resources/rawfile/showroom/index.html entry/src/main/resources/rawfile/showroom/styles.css entry/src/main/resources/rawfile/showroom/app.js entry/src/main/resources/rawfile/showroom/lib/three.min.js entry/src/main/resources/rawfile/showroom/lib/OrbitControls.js
```

- [ ] **Step 5: Verify build**

Run: `DEVECO_SDK_HOME=/Applications/DevEco-Studio.app/Contents/sdk node /Applications/DevEco-Studio.app/Contents/tools/hvigor/bin/hvigorw.js --mode module -p module=entry@default -p product=default assembleHap`

Expected: the entry module builds successfully with the native showroom page.

- [ ] **Step 6: Commit**

```bash
git add entry/src/main/ets/pages/ShowroomPage.ets entry/src/main/resources/rawfile/showroom/models/aurora_x_showcar.gltf entry/src/main/ets/common/showroom/ShowroomData.ets
git commit -m "feat: switch showroom to native arkgraphics3d"
```
