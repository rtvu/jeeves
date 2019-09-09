<template>
  <div>
    <div class="row my-2">
      <div class="col">
        <selector-group>
          <template #selector-prepend>
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
          </template>
          <template #selector>
            <input
              type="text"
              class="form-control form-control-sm"
              readonly

              :value="model.selection">
          </template>
        </selector-group>
      </div>
    </div>

    <b-modal
      no-close-on-esc
      no-close-on-backdrop
      hide-header-close
      size="lg"

      v-model="model.modalShow"

      :title="'Select ' + resource">
      <nav class="p-1">
        <ol class="breadcrumb m-0">
          <li class="breadcrumb-item" v-for="(crumb, index) in model.modalPathCrumbHeads">
            <a href="#" @click="crumbClick(index); return false;">{{ crumb }}</a>
          </li>
          <li class="breadcrumb-item active">
            {{ model.modalPathCrumbTail }}
          </li>
        </ol>
      </nav>

      <div class="input-group input-group-sm p-1">
        <div class="input-group-prepend">
          <span class="input-group-text"><i class="fas fa-search fa-fw text-secondary"></i></span>
        </div>
        <input class="form-control" v-model="model.modalSearch" type="text" style="background-color: transparent;">
        <div class="input-group-append">
          <button class="btn btn-secondary" type="button" @click="clearSearchButton">Clear</button>
        </div>
      </div>

      <div class="p-1" style="overflow-y: auto; max-height: 50vh;">
        <div class="input-group input-group-sm" v-for="folder in showFolders">
          <div class="input-group-prepend">
            <span class="input-group-text"><i class="far fa-folder fa-fw text-info"></i></span>
          </div>
          <input type="text" :class="foldersListClass(folder)" readonly @click="clickFolder(folder)" @dblclick="doubleClickFolder(folder)" :value="folder" style="background-color: transparent;">
        </div>
        <div class="input-group input-group-sm" v-for="file in showFiles">
          <div class="input-group-prepend">
            <span class="input-group-text"><i class="far fa-file fa-fw text-success"></i></span>
          </div>
          <input type="text" :class="filesListClass(file)" readonly @click="clickFile(file)" :value="file" style="background-color: transparent;">
        </div>
      </div>
      <div slot="modal-footer" class="w-100">
        <div class="float-left">
          <button type="button" class="btn btn-sm btn-warning" @click="clearModalButton">Clear</button>
        </div>
        <div class="float-right">
          <button type="button" class="btn btn-sm btn-secondary" @click="cancelModalButton">Cancel</button>
          <button type="button" class="btn btn-sm btn-primary" @click="selectModalButton" :disabled="model.selectButtonDisabled">Select</button>
        </div>
      </div>
    </b-modal>
  </div>
</template>

<script>
  import { onMounted, reactive, watch, computed } from "@vue/composition-api"
  import tooltipTextFlexButton from "../utilities/tooltip-text-flex-button"
  import getServerFileExplorerChannel from "../../get-server-file-explorer-channel"
  import pathHelper from "path"
  import selectorGroup from "../utilities/selector-group"

  export default {
    inheritAttrs: false,
    components: {
      "tooltip-text-flex-button": tooltipTextFlexButton,
      "selector-group": selectorGroup
    },
    props: {
      resource: {
        type: String,
        default: ""
      },
      defaultPath: {
        type: String,
        default: ""
      },
      value: {
        type: String,
        default: ""
      },
      type: {
        type: String,
        default: "files"
      },
      disabled: {
        type: Boolean,
        default: false
      }
    },
    setup(props, context) {
      const model = reactive({
        path: "",
        selection: "",
        selectButtonDisabled: true,
        modalShow: false,
        modalPathCrumbTail: "",
        modalPathCrumbHeads: [],
        modalFiles: "",
        modalFolders: "",
        modalSelectedItem: "",
        modalSearch: ""
      })

      let serverFileExplorerChannel = getServerFileExplorerChannel()

      const showFiles = computed(() => {
        if (model.modalSearch === "") {
          return model.modalFiles
        } else {
          return model.modalFiles.filter((file) => file.includes(model.modalSearch))
        }
      })

      const showFolders = computed(() => {
        if (model.modalSearch === "") {
          return model.modalFolders
        } else {
          return model.modalFolders.filter((folder) => folder.includes(model.modalSearch))
        }
      })

      function launchModal() {
        model.modalShow = true
        listPathContents(model.path)
      }

      function listPathContents(path) {
        //  Clean up previous interaction
        model.modalSelectedItem = ""
        model.modalSearch = ""

        serverFileExplorerChannel.push("list-path-contents", { path: path })
          .receive("ok", response => {
            path = "./" + path
            let pathCrumb = path.replace(/\/+$/, "").split("/")
            model.modalPathCrumbTail = pathCrumb.pop()
            model.modalPathCrumbHeads = pathCrumb

            model.modalFiles = response.files
            model.modalFolders = response.folders
          })
      }

      function checkPathExists(path, path_type) {
        if (props.value !== "") {
          let requestMap = {
            files: "does-file-exist",
            folders: "does-folder-exist",
            both: "does-path-exist"
          }
          let request = requestMap[path_type]

          serverFileExplorerChannel.push(request, { path: path })
            .receive("ok", response => {
              if (response.exists) {
                model.path = pathHelper.dirname(path) + "/"
                model.selection = pathHelper.basename(path)
              } else {
                model.path = props.defaultPath
                model.selection = ""
              }
            }
          )
        } else {
          model.path = props.defaultPath
          model.selection = ""
        }
      }

      function crumbClick(index) {
        if (index === 0) {
          listPathContents("")
        } else {
          listPathContents(model.modalPathCrumbHeads.slice(1, index + 1).join("/") + "/")
        }
      }

      function foldersListClass(folder) {
        if (folder === model.modalSelectedItem.folder) {
          return ["form-control", "font-weight-bold", "text-primary"]
        } else {
          return ["form-control"]
        }
      }

      function clickFolder(folder) {
        model.modalSelectedItem = {folder: folder}
      }

      function doubleClickFolder(folder) {
        if (model.modalPathCrumbTail === ".") {
          listPathContents(folder + "/")
        } else {
          listPathContents(model.modalPathCrumbHeads.slice(1).concat([model.modalPathCrumbTail, folder]).join("/") + "/")
        }
      }

      function filesListClass(file) {
        if (file === model.modalSelectedItem.file) {
          return ["form-control", "font-weight-bold", "text-primary"]
        } else {
          return ["form-control"]
        }
      }

      function clickFile(file) {
        model.modalSelectedItem = {file: file}
      }

      function clearModalButton() {
        model.path = props.defaultPath
        model.selection = ""
        model.modalShow = false
      }

      function cancelModalButton() {
        model.modalShow = false
      }

      function selectModalButton() {
        model.path = model.modalPathCrumbHeads.slice(1).concat([model.modalPathCrumbTail]).join("/") + "/"
        model.selection = model.modalSelectedItem[Object.keys(model.modalSelectedItem)[0]]
        model.modalShow = false
      }

      function clearSearchButton() {
        model.modalSearch = ""
      }

      onMounted(() => {
        checkPathExists(props.value, props.type)

        watch(
          () => props.value,
          (value) => {
            checkPathExists(value, props.type)
          }
        )

        watch(
          () => model.modalSelectedItem,
          (item) => {
            if (item === "") {
              model.selectButtonDisabled = true
            } else if ((props.type === "files") && item.hasOwnProperty("folder")) {
              model.selectButtonDisabled = true
            } else {
              model.selectButtonDisabled = false
            }
          }
        )

        watch(
          () => model.selection,
          (selection) => {
            if (selection === "") {
              context.emit("input", "")
            } else {
              context.emit("input", model.path + model.selection)
            }
          }
        )
      })

      return {
        model,
        showFiles,
        showFolders,
        checkPathExists,
        launchModal,
        listPathContents,
        crumbClick,
        foldersListClass,
        clickFolder,
        doubleClickFolder,
        filesListClass,
        clickFile,
        clearModalButton,
        cancelModalButton,
        selectModalButton,
        clearSearchButton
      }
    }
  }
</script>
