import { BasicDataSource } from '../utils/BasicDatSource';

/**
 * 数据源类*/
export class DataSource<T> extends BasicDataSource {
  /**
   * 数据源*/
  private DataArray: T[] = [];

  constructor(el: T[]) {
    super();
    this.DataArray = el;
  }

  public totalCount(): number {
    return this.DataArray.length;
  }

  public getData(index: number): T {
    return this.DataArray[index];
  }

  public addData(index: number, data: T): void {
    this.DataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: T): void {
    this.DataArray.push(data);
    this.notifyDataAdd(this.DataArray.length - 1);
  }

  /**
   * 添加一组数据
   * @param data 原始数据
   * @param flag true头部追加 false底部追加
   * @param start 开始索引
   * @param end 结束索引 */
  pushArrayData(data: T[], flag: boolean, start: number, end: number) {
    const result = data.slice(start, end)
    flag ? this.DataArray.unshift(...result) : this.DataArray.push(...result)
    this.notifyDataAdd(this.DataArray.length - 1)
  }

  /**
   * 重新赋值
   * @param data 原始数据 */
  public reload(data: T[]) {
    this.DataArray = data
    this.notifyDataReload()
  }
}
