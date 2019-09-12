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
      v-model="model.modalShow"
      :resource="resource"
      :path="model.path"
      :selection="model.selection"
      :files="model.modalFiles"
      :folders="model.modalFolders"
      :type="type"

      @list-path-contents="handleListPathContents($event)"
      @clear="handleClear()"
      @select="handleSelect($event)">
    </modal-path-selector>
  </div>
</template>

<script>
  import Vue from "vue"
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
        default: "files",
        validator: function(value) {
          return (["files", "folders", "both"].indexOf(value) !== -1)
        }
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
        modalFolders: []
      })

      //  Get the serverFileExplorerChannel.
      let serverFileExplorerChannel = getServerFileExplorerChannel()

      //  Gets list of folders and list of files from the server based on
      //  'path'.
      function listPathContents(path) {
        serverFileExplorerChannel.push("list-path-contents", { path: path })
          .receive("ok", response => {
            if (props.type === "folders") {
              model.modalFiles = []
            } else {
              model.modalFiles = response.files
            }

            model.modalFolders = response.folders
          })
      }


      //  Initializes and triggers modal.
      function handleLaunchModalClick() {
        listPathContents(model.path)
        model.modalShow = true
      }

      function checkValuePathExists() {
        let value = props.value.replace(/\/+$/, "/")

        let isValueEmpty = (value === "")
        let isValueFoldersClash = ((props.type === "folders") && (value.slice(-1) !== "/"))
        let isValueFilesClash = ((props.type === "files") && (value.slice(-1) === "/"))

        if (isValueEmpty || isValueFoldersClash || isValueFilesClash) {
          model.path = props.defaultPath
          model.selection = ""
        } else {
          let request = ""
          if (value.slice(-1) === "/") {
            request = "does-folder-exist"
          } else {
            request = "does-file-exist"
          }

          serverFileExplorerChannel.push(request, { path: value })
            .receive("ok", response => {
              if (response.exists) {
                model.path = pathHelper.dirname(value) + "/"

                model.selection = pathHelper.basename(value)
                if (request === "does-folder-exist") {
                  model.selection += "/"
                }
              } else {
                model.path = props.defaultPath
                model.selection = ""
              }
            }
          )
        }
      }

      onMounted(() => {
        checkValuePathExists()

        watch(
          () => props.value,
          (value) => {
            console.log("hello")
            console.log("value" + props.value)
            console.log("ps: "+model.path + model.selection)
            if (props.value !== model.path + model.selection) {
              checkValuePathExists()
            }
          }
        )
      })

      function handleListPathContents(path) {
        listPathContents(path)
      }

      function handleClear() {
        model.path = ""
        model.selection = ""
      }



      function handleSelect(object) {
        model.path = object.path
        model.selection = object.selection
      }


      return {
        model,
        handleLaunchModalClick,
        checkValuePathExists,

        handleListPathContents,
        handleClear,
        handleSelect
      }
    }
  }
</script>
