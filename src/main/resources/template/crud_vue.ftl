<template>
  <section>
    <el-card class="content-box">
      <div slot="header">${data.desc}</div>
      <el-form :inline="true" :model="search" class="demo-form-inline">
        <#list data.pairs as p>
          <el-form-item label="${p.comment}">
            <el-input v-model.trim="search.${p.field}"></el-input>
          </el-form-item>
        </#list>
        <el-form-item>
          <el-button type="primary" @click="onSubmit" icon="el-icon-search">查询</el-button>
          <el-button type="primary" @click="onClean" icon="el-icon-refresh">重置</el-button>
        </el-form-item>
      </el-form>

    </el-card>
    <el-card class="content-box">
      <el-row class="is-btnBox">
        <el-button type="primary" round @click="add()">新增</el-button>
      </el-row>
      <el-table
        :data="tableData"
        border
        style="width: 100%">
        <el-table-column
          type="index"
          :index="1"
          label="序号">
        </el-table-column>
        <#list data.pairs as p>
        <el-table-column
                prop="${p.field}"
                label="${p.comment}">
        </el-table-column>
        </#list>
        <el-table-column
          fixed="right"
          label="操作">
          <template slot-scope="scope">
            <el-button @click="edit(scope.row)" type="text" size="small">编辑</el-button>
            <el-button @click="remove(scope.row)" type="text" size="small">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination
        background
        :current-page="pageInfo.pageIndex"
        :page-sizes="[10, 50, 100]"
        :page-size="pageInfo.pageSize"
        layout="total, sizes, prev, pager, next, jumper"
        :total="pageInfo.total"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </el-card>

    <el-dialog :title="formTitle" :visible.sync="dialogVisible" :before-close="handleClose" width="40%">
      <el-form :model="${data._modelName}" :rules="rules" ref="${data._modelName}" label-position="right" label-width="125px"
               class="demo-ruleForm">
        <#list data.pairs as p>
          <el-form-item label="${p.comment}" prop="${p.field}">
            <el-input v-model="${data._modelName}.${p.field}" placeholder="${p.comment}"></el-input>
          </el-form-item>
        </#list>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="submitDialog">确 定</el-button>
      </span>
    </el-dialog>


  </section>
</template>

<script>
  import ${data._modelName} from '@/api/${data._modelName}';

  export default {

    data() {
      return {
        search: {},
        tableData: [],
        pageInfo: {
          pageIndex: 1,
          pageSize: 10,
          total: 0
        },
        ${data._modelName}: {
          <#list data.pairs as p>
              ${p.field}:null<#if p_has_next>,</#if>
          </#list>
        },
        isAdd: true,
        dialogVisible: false,
        rules: {}
      }
    },
    computed: {
      formTitle: function () {
        if (this.isAdd) {
          return "新增"
        } else {
          return "编辑"
        }
      }
    },

    created() {
      this.getTableDate();
    },
    methods: {
      // 每页展示数量
      handleSizeChange(val) {
        this.pageInfo.pageIndex = 1;
        this.pageInfo.pageSize = val;
        this.getTableDate();
      },
      // 翻页
      handleCurrentChange(val) {
        this.pageInfo.pageIndex = val;
        this.getTableDate();
      },
      getTableDate() {
        let params = this.search;
        params.pageSize = this.pageInfo.pageSize;
        params.pageIndex = this.pageInfo.pageIndex;
        ${data._modelName}.queryPage(params).then(response => {
          this.pageInfo.total = response.data.pageCond.count;
          this.tableData = response.data.list;
        });
      },
      //编辑
      edit(row) {
        this.dialogVisible = true;
        this.isAdd = false;
        <#list data.pairs as p>
        this.${data._modelName}.${p.field} = row.${p.field};
        </#list>
      },

      remove(row) {
        ${data._modelName}.remove({id: row.id}).then(response => {
          if (response.code !== '1') {
            this.$message.error("删除失败！");
           } else {
            this.$message.success("删除成功！");
            this.getTableDate();
          }
        });
      },

      //查询操作
      onSubmit() {
        this.getTableDate();
      },
      //重置按钮
      onClean() {
          this.search={};
      },
      //进入添加页面
      add() {
        this.${data._modelName} = {};
        this.dialogVisible = true;
        this.isAdd = true;
      },
      submitDialog() {
        this.$refs['${data._modelName}'].validate(validate => {
          if (validate) {
            ${data._modelName}.saveOrUpdate(this.${data._modelName}).then(response => {
              if (response.code !== '1') {
              this.$message.error("保存失败！");
            } else {
              this.$message.success("保存成功！");
            }
          });
            this.dialogVisible = false;
            this.getTableDate();
          } else {
            this.$message.error("表单不合法");
          }
        });
      },

      handleClose(done) {
        this.$confirm('确认关闭？')
          .then(_ => {
            done();
          })
          .catch(_ => {
          });
      }
    }
  }
</script>
