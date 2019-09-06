<template>
  <div>
    <div class="row my-2">
      <div class="col">
        <div class="input-group">
          <div class="input-group-prepend w-10">
            <tooltip-text-flex-button
              div-class="w-100"
              button-class="btn btn-sm btn-dark btn-block"
              button-style="border-top-right-radius: 0; border-bottom-right-radius: 0;"

              :disabled="disabled"
              :html="resource"
              :title="resource"
              @click="launchModal"

              v-bind="$attrs"
              v-on="$listeners">
            </tooltip-text-flex-button>
          </div>
          <input type="text" class="form-control form-control-sm" readonly :value="file">
        </div>
      </div>
    </div>

    <b-modal v-model="modalShow" :no-close-on-esc="true" :no-close-on-backdrop="true" :hide-header-close="true" :title="'Select ' + resource">
      <nav>
        <ol class="breadcrumb">
          <li class="breadcrumb-item" v-for="(crumb, index) in pathCrumb" v-if="pathCrumb.length != index + 1">
            <a href="#" @click="crumbClick(index); return false;">{{ crumb }}</a>
          </li>
          <li class="breadcrumb-item active" v-for="(crumb, index) in pathCrumb" v-if="pathCrumb.length == index + 1">
            {{ crumb }}
          </li>
        </ol>
      </nav>
      <div style="overflow-y:auto;max-height:50vh;">
        <div class="input-group input-group-sm" v-for="folder in folders">
          <div class="input-group-prepend">
            <span class="input-group-text"><i class="far fa-folder fa-fw text-primary"></i></span>
          </div>
          <input type="text" :class="foldersListClass(folder)" readonly @click="clickFolder(folder)" @dblclick="doubleClickFolder(folder)" :value="folder" style="background-color:transparent;">
        </div>
        <div class="input-group input-group-sm" v-for="file in files">
          <div class="input-group-prepend">
            <span class="input-group-text"><i class="far fa-file fa-fw text-success"></i></span>
          </div>
          <input type="text" :class="filesListClass(file)" readonly @click="clickFile(file)" :value="file" style="background-color:transparent;">
        </div>
      </div>
      <div slot="modal-footer" class="w-100">
        <div class="float-left">
          <button type="button" class="btn btn-sm btn-warning" @click="clearModalButton">Clear</button>
        </div>
        <div class="float-right">
          <button type="button" class="btn btn-sm btn-secondary" @click="cancelModalButton">Cancel</button>
          <button type="button" class="btn btn-sm btn-primary" @click="selectModalButton" :disabled="selectButtonDisabled">Select</button>
        </div>
      </div>
    </b-modal>
  </div>
</template>

<script>
  import tooltipTextFlexButton from "../utilities/tooltip-text-flex-button"
  import getServerFileExplorerChannel from "../../get-server-file-explorer-channel"
  import pathHelper from "path"

  export default {
    inheritAttrs: false,
    components: {
      "tooltip-text-flex-button": tooltipTextFlexButton
    },
    props: {
      resource: String,
      defaultPath: String,
      value: String,
      disabled: {
        type: Boolean,
        default: false
      },
    },
    data () {
      return {
        path: "",
        file: "",
        modalShow: false,
        selectButtonDisabled: true,
        pathCrumb: "",
        files: "",
        folders: "",
        selectedItem: ""
      }
    },
    watch: {
      selectedItem (item) {
        if (item.hasOwnProperty('file') && item.file != "" ) {
          this.selectButtonDisabled = false;
        } else {
          this.selectButtonDisabled = true;
        }
      },
      value (value) {
        this.checkFileExists(value)
      },
      file (file) {
        if (file == "") {
          this.$emit("input", "")
        } else {
          this.$emit("input", this.path + this.file)
        }
      }
    },
    created () {
      this.serverFileExplorerChannel = getServerFileExplorerChannel()

      this.checkFileExists(this.value)
    },
    methods: {
      checkFileExists (path) {
        if (this.value != "") {
          this.serverFileExplorerChannel.push("does-file-exist", { path: path })
            .receive("ok", resp => {
              if (resp.exists) {
                this.path = pathHelper.dirname(path) + "/";
                this.file = pathHelper.basename(path);
              } else {
                this.path = this.defaultPath;
                this.file = "";
              }
          })
        } else {
          this.path = this.defaultPath;
          this.file = "";
        }
      },
      launchModal () {
        this.requestFolder(this.path)
        this.modalShow = !this.modalShow
      },
      requestFolder (path) {
        this.selectedItem = ""

        this.serverFileExplorerChannel.push("list-path-contents", { path: path })
          .receive("ok", resp => {
            this.pathCrumb = path.replace(/\/+$/, "").split("/")
            this.files = resp.files
            this.folders = resp.folders
          })
      },
      crumbClick (index) {
        this.requestFolder(this.pathCrumb.slice(0, index + 1).join("/") + "/")
      },
      foldersListClass(folder) {
        if (folder == this.selectedItem.folder) {
          return ["form-control", "font-weight-bold", "text-primary"]
        } else {
          return ["form-control"]
        }
      },
      clickFolder (folder) {
        this.selectedItem = {folder: folder}
      },
      doubleClickFolder (folder) {
        this.requestFolder(this.pathCrumb.concat([folder]).join("/") + "/")
      },
      filesListClass(file) {
        if (file == this.selectedItem.file) {
          return ["form-control", "font-weight-bold", "text-primary"]
        } else {
          return ["form-control"]
        }
      },
      clickFile (file) {
        this.selectedItem = {file: file}
      },
      clearModalButton () {
        this.selectedItem = ""
        this.file = ""
        this.modalShow = false
      },
      cancelModalButton () {
        this.selectedItem = ""
        this.modalShow = false
      },
      selectModalButton () {
        this.path = this.pathCrumb.join("/") + "/"
        this.file = this.selectedItem.file
        this.selectedItem = ""
        this.modalShow = false
      }
    }
  }
</script>
