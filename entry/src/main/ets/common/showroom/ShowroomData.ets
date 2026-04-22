export interface ShowroomExhibit {
  title: string
  subtitle: string
  description: string
  gestureHint: string
  runtimeHint: string
  tags: string[]
}

export const SHOWROOM_EXHIBIT: ShowroomExhibit = {
  title: 'Dog Ziwen 模型',
  subtitle: 'ArkGraphics3D 原生 3D 查看器',
  description: '展示区当前接入了桌面提供的本地 GLB 人物模型，页面中间直接通过 ArkGraphics3D 加载资源。用户可以单指上下左右拖动，从不同角度观察模型，也可以双指捏合拉近拉远，后续如果继续换模型，只需要替换 rawfile 资源和加载路径。',
  gestureHint: '单指上下左右拖动可切换视角，双指捏合可拉近拉远',
  runtimeHint: 'Previewer 暂不支持 Component3D，请以鸿蒙模拟器或真机效果为准。',
  tags: ['ArkGraphics3D', '人物模型', '本地 GLB']
}
