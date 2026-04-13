export interface ShowroomExhibit {
  title: string
  subtitle: string
  description: string
  gestureHint: string
  runtimeHint: string
  tags: string[]
}

export const SHOWROOM_EXHIBIT: ShowroomExhibit = {
  title: 'Aurora X 概念车',
  subtitle: 'ArkGraphics3D 原生 3D 展品',
  description: '这台展车改成了鸿蒙原生 ArkGraphics3D 渲染链路，页面中间直接由 Component3D 加载本地 glTF 车模，不再依赖 Web 壳。首版支持自动巡航旋转、单指环绕查看和双指缩放，方便后续替换成正式车模资源。',
  gestureHint: '单指拖动可环绕，双指捏合可缩放，静止后会自动缓慢巡航',
  runtimeHint: 'Previewer 暂不支持 Component3D，请以鸿蒙模拟器或真机效果为准。',
  tags: ['ArkGraphics3D', '原生 3D', '本地 glTF']
}
