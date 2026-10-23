import { fileIo } from '@kit.CoreFileKit'
import { Constants } from '../common/Constants'

/**
 * 文件操作*/
class File {
  /**
   * 惰性获取UI实例context 避免模块加载期裸调用getContext*/
  private static getCtx(): Context {
    return AppStorage.get<Context>(Constants.GET_CONTEXT)!
  }

  /**
   * 创建文件*/
  static crateAudioFile(userId: string) {
    const dir = File.getCtx().filesDir + '/' + userId
    const flag = fileIo.accessSync(dir)
    if (!flag) {
      fileIo.mkdirSync(dir)
    }
    //时间戳与扩展名之间必须有点号 否则生成的文件无法被识别
    let filePath = dir + '/' + Date.now() + '.wav'
    const file = fileIo.openSync(filePath, fileIo.OpenMode.CREATE)
    fileIo.closeSync(file)
    return filePath
  }

  /**
   * 删除一个文件*/
  static delFile(filePath: string) {
    if (filePath) {
      fileIo.unlinkSync(filePath)
    }
  }

  /**
   * 删除用户目录*/
  static delUserPath(userId: string) {
    if (userId) {
      const dir = File.getCtx().filesDir + '/' + userId
      const flag = fileIo.accessSync(dir)
      if (flag) {
        fileIo.rmdirSync(dir)
      }
    }
  }
}