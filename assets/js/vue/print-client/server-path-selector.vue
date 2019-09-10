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

              @click="handleLaunchModalClick()"

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

    <!-- <modal-path-selector
      :show="model.modalShow"
      :resource="resource"
      :path="model.path"
      :selection="model.selection"
      :files="model.modalFiles"
      :folders="model.modalFolders"
      :type="type"

      @list-path-contents="handleListPathContents($event)"
      @clear="handleClear()"
      @close="handleClose()"
      @cancel="handleCancel()"
      @select="handleSelect($event)">
    </modal-path-selector> -->
    <modal-path-selector
      :show="model.modalShow"
      :resource="resource"
      :path="model.path"
      :selection="model.selection"
      :files="model.modalFiles"
      :folders="model.modalFolders"
      :type="type">
    </modal-path-selector>
  </div>
</template>

<script>
  import { onMounted, reactive, watch, computed } from "@vue/composition-api"
  import tooltipTextFlexButton from "../utilities/tooltip-text-flex-button"
  import getServerFileExplorerChannel from "../../get-server-file-explorer-channel"
  import pathHelper from "path"
  import selectorGroup from "../utilities/selector-group"
  import modalPathSelector from "../utilities/modal-path-selector"

  export default {
    inheritAttrs: false,
    components: {
      "tooltip-text-flex-button": tooltipTextFlexButton,
      "selector-group": selectorGroup,
      "modal-path-selector": modalPathSelector
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
        modalShow: false,
        modalFiles: [],
        modalFolders: [],
      })

      let serverFileExplorerChannel = getServerFileExplorerChannel()

      function handleLaunchModalClick() {
        model.modalShow = true
      }

      function listPathContents(path) {
        serverFileExplorerChannel.push("list-path-contents", { path: path })
          .receive("ok", response => {
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
        handleLaunchModalClick,






        showFiles,
        showFolders,
        checkPathExists,

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
