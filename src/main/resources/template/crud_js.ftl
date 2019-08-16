import request from '@/utils/request'

export default {

  /**
   *  分页列表
   * @param param
   * @returns {*}
   */
  queryPage(param) {
    return request.postJSON('/${data._modelName}/queryPage.do', param)
  },

  saveOrUpdate(param) {
    return request.postJSON('/${data._modelName}/saveOrUpdate.do', param)
  }
}
