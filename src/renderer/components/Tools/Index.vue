<template>
  <div class="main-right-panel">
    <ul class="tools-panel">
      <li @click="showPage('sslmake')">
        <mo-icon name="sslmake" width="30" height="30" />
        <span>SSL Make</span>
      </li>
      <li @click="showPage('fileinfo')">
        <mo-icon name="fileinfo" width="30" height="30" />
        <span>File Info</span>
      </li>
    </ul>
    <el-drawer
      size="65%"
      title="我是标题"
      :visible.sync="show"
      :wrapperClosable="false"
      :destroy-on-close="true"
      custom-class="host-edit-drawer"
      ref="host-edit-drawer"
      :with-header="false">
      <component :is="component" @doClose="hidePage"></component>
    </el-drawer>
  </div>
</template>

<script>
  import '@/components/Icons/sslmake'
  import '@/components/Icons/fileinfo'
  import SSLMake from './SSLMake'
  import FileInfo from './FileInfo'
  export default {
    components: {},
    data () {
      return {
        show: false,
        component: null
      }
    },
    computed: {},
    methods: {
      showPage (flag) {
        this.show = true
        switch (flag) {
          case 'sslmake':
            this.component = SSLMake
            break
          case 'fileinfo':
            this.component = FileInfo
            break
        }
      },
      hidePage () {
        this.component = null
        this.show = false
      }
    }
  }
</script>

<style lang="scss">
  .tools-panel{
    padding: 40px;
    display: grid;
    grid-row-gap: 40px;
    grid-column-gap: 40px;
    grid-template-columns: repeat(auto-fill, 120px);
    grid-template-rows: repeat(auto-fill, 150px);

    > li {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      width: 120px;
      height: 150px;
      background: #32364a;
      border-radius: 5px;
      padding-top: 5px;
      cursor: pointer;
      transition: all 0.25s;
      user-select: none;

      &:hover {
        transform: scale(1.1);
      }

      > span {
        margin-top: 25px;
      }
    }
  }
</style>
