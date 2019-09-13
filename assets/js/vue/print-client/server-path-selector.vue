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

    <modal-path-selector
      v-model="model.modalShow"
      :resource="resource"
      :path="model.path"
      :selection="model.selection"
      :files="model.modalFiles"
      :folders="model.modalFolders"
      :type="type"

      @set-path="handleSetPath($event)"
      @clear="handleClear()"
      @cancel="handleCancel()"
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

      //  Emits updated value.
      function emitValue(value) {
        context.emit("input", value)
      }

      //  Get the serverFileExplorerChannel.
      let serverFileExplorerChannel = getServerFileExplorerChannel()

      //  Gets list of folders and list of files from the server based on
      //  'path'.
      function listPathContents() {
        serverFileExplorerChannel.push("list-path-contents", { path: model.path })
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
        listPathContents()
        model.modalShow = true
      }

      //  Checks if 'props.value' path eists. If path exists, then set
      //  'model.path' and 'model.selection'.
      function checkValuePathExists() {
        //  Conditions where 'props.value' path should not be checked.
        let isValueEmpty = (props.value === "")
        let isValueFoldersClash = ((props.type === "folders") && (props.value.slice(-1) !== "/"))
        let isValueFilesClash = ((props.type === "files") && (props.value.slice(-1) === "/"))

        if (isValueEmpty || isValueFoldersClash || isValueFilesClash) {
          //  Set 'model.path' and 'model.selection' when path checking is not
          //  needed.
          model.path = props.defaultPath
          model.selection = ""
        } else {
          //  Determines if path request is for file or folder.
          let request = ""
          if (props.value.slice(-1) === "/") {
            request = "does-folder-exist"
          } else {
            request = "does-file-exist"
          }

          // Sends request to server.
          serverFileExplorerChannel.push(request, { path: props.value })
            .receive("ok", response => {
              //  Handles response.
              if (response.exists) {
                model.path = pathHelper.dirname(props.value) + "/"

                model.selection = pathHelper.basename(props.value)
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

      //  Handles listing path contents.
      function handleSetPath(path) {
        model.path = path
        listPathContents()
      }

      //  Handles clearing state.
      function handleClear() {
        model.path = props.defaultPath
        model.selection = ""
      }

      // Handles selecting new path.
      function handleSelect(object) {
        model.path = object.path
        model.selection = object.selection
        emitValue(model.path + model.selection)
      }

      watch(
        () => props.value,
        (value) => {
          //  Formats value.
          let formattedValue = value.replace(/\/+$/, "/")

          if (formattedValue !== value) {
            //  Emit 'formattedValue'.
            emitValue(formattedValue)
          } else {
            if (value !== model.path + model.selection) {
              //  Value has been updated if not equal to
              //  'model.path + model.selection'.
              checkValuePathExists()
            }
          }
        }
      )

      return {
        model,
        handleLaunchModalClick,
        checkValuePathExists,
        handleSetPath,
        handleClear,
        handleSelect
      }
    }
  }
</script>
