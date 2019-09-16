<!--
  'modal-path-selector' is a wrapper around 'b-modal' to sepcialize in
  presenting a file/folder selection interface. Selection menu is solely
  determined by props. Internal data is used for rendering and tracking
  selection. Parent component receives events in order to update selection menu
  or receive selection.
-->

<template>
  <!-- Modal -->
  <b-modal
    no-close-on-esc
    no-close-on-backdrop
    hide-header-close
    size="lg"

    :visible="visible"

    :title="'Select: ' + resource">

    <!-- Path Breadcrumb -->
    <nav class="p-1">
      <ol class="breadcrumb m-0">
        <li class="breadcrumb-item" v-for="(crumb, index) in model.pathCrumbHeads">
          <a href="#" @click="handleCrumbClick(index); return false;">
            {{ crumb }}
          </a>
        </li>
        <li class="breadcrumb-item active">
          {{ model.pathCrumbTail }}
        </li>
      </ol>
    </nav>

    <!-- Search -->
    <div class="input-group input-group-sm p-1">
      <div class="input-group-prepend">
        <span class="input-group-text"><i class="fas fa-search fa-fw text-secondary"></i></span>
      </div>
      <input class="form-control" v-model="model.search" type="text" style="background-color: transparent;">
      <div class="input-group-append">
        <button class="btn btn-secondary" type="button" @click="handleClearSearchClick">Clear</button>
      </div>
    </div>

    <!-- File and Folder Selection Menu -->
    <div class="p-1" style="overflow-y: auto; max-height: 50vh;">
      <!-- Folders List -->
      <div class="input-group input-group-sm" v-for="folder in showFolders">
        <div class="input-group-prepend">
          <span class="input-group-text"><i class="far fa-folder fa-fw text-info"></i></span>
        </div>
        <input type="text" :class="foldersListClass(folder)" readonly @click="handleFolderClick(folder)" @dblclick="handleFolderDoubleClick(folder)" :value="folder" style="background-color: transparent;">
      </div>

      <!-- Files List -->
      <div class="input-group input-group-sm" v-for="file in showFiles">
        <div class="input-group-prepend">
          <span class="input-group-text"><i class="far fa-file fa-fw text-success"></i></span>
        </div>
        <input type="text" :class="filesListClass(file)" readonly @click="handleFileClick(file)" :value="file" style="background-color: transparent;">
      </div>
    </div>

    <!-- Footer Buttons -->
    <template #modal-footer>
      <div class="w-100">
        <div class="float-left">
          <button type="button" class="btn btn-sm btn-warning" @click="handleClearFooterClick">Clear</button>
        </div>
        <div class="float-right">
          <button type="button" class="btn btn-sm btn-secondary" @click="handleCancelFooterClick">Cancel</button>
          <button type="button" class="btn btn-sm btn-primary" @click="handleSelectFooterClick" :disabled="model.selectFooterButtonDisabled">Select</button>
        </div>
      </div>
    </template>
  </b-modal>
</template>

<script>
  import { reactive, watch, computed } from "@vue/composition-api"

  //  'array' will be filtered to contain 'search' unless search is empty.
  function searchFilter(array, search) {
    if (search === "") {
      return array
    } else {
      return array.filter(item => item.includes(search))
    }
  }

  export default {
    model: {
      prop: "visible",
      event: "change"
    },
    props: {
      resource: {
        type: String,
        default: ""
      },
      visible: {
        type: Boolean,
        default: false
      },
      path: {
        type: String,
        default: ""
      },
      selection: {
        type: String,
        default: ""
      },
      files: {
        type: Array,
        default: function () {
          return []
        }
      },
      folders: {
        type: Array,
        default: function () {
          return []
        }
      },
      type: {
        type: String,
        default: "files",
        validator: function(value) {
          return (["files", "folders", "both"].indexOf(value) !== -1)
        }
      },
    },
    setup(props, context) {
      const model = reactive({
        search: "",
        selectFooterButtonDisabled: true,
        selectedItem: "",
        pathCrumbTail: "",
        pathCrumbHeads: []
      })

      //  Array for folders to show.
      const showFolders = computed(() => {
        return searchFilter(props.folders, model.search)
      })

      //  Array for files to show.
      const showFiles = computed(() => {
        if (props.type === "folders") {
          return []
        } else {
          return searchFilter(props.files, model.search)
        }
      })

      //  'pathCrumbTail' and 'pathCrumbHeads' are depedent on 'props.path'
      watch(
        () => props.path,
        (path) => {
          //  ("./" + path) ==> add "." to path
          //  replace(/\/+$/, "") ==> remove ending "/"
          //  split("/") ==> split by "/"
          let partitionedPath = ("./" + path).replace(/\/+$/, "").split("/")
          model.pathCrumbTail = partitionedPath.pop()
          model.pathCrumbHeads = partitionedPath
        }
      )

      //  'model.selectedItem' gets reinitialized whenever 'props.show'
      //  turns 'true'.
      watch(
        () => props.show,
        (show) => {
          if (show) {
            if (props.selection === "") {
              model.selectedItem = ""
            } else if (props.selection.slice(-1) === "/") {
              model.selectedItem = { folder: props.selection.slice(0, -1) }
            } else {
              model.selectedItem = { file: props.selection }
            }
          }
        }
      )

      //  'model.selectedItem' change triggers setting state for
      //  'model.selectFooterButtonDisabled'.
      watch(
        () => model.selectedItem,
        (item) => {
          if (item === "") {
            model.selectFooterButtonDisabled = true
          } else if ((props.type === "files") && item.hasOwnProperty("folder")) {
            model.selectFooterButtonDisabled = true
          } else {
            model.selectFooterButtonDisabled = false
          }
        }
      )

      //  Defines appearance for each folder.
      function foldersListClass(folder) {
        if (folder === model.selectedItem.folder) {
          return ["form-control", "font-weight-bold", "text-primary"]
        } else {
          return ["form-control"]
        }
      }

      //  Defines appearance for each file.
      function filesListClass(file) {
        if (file === model.selectedItem.file) {
          return ["form-control", "font-weight-bold", "text-primary"]
        } else {
          return ["form-control"]
        }
      }

      //  Emits request for path update.
      function emitSetPath(path) {
        context.emit("set-path", path)
      }

      //  Clears 'search'.
      function clearSearch() {
        model.search = ""
      }

      //  Clears 'model.selectedItem'.
      function clearSelectedItem() {
        model.selectedItem = ""
      }

      //  Emits modal should be closed.
      function closeModal() {
        context.emit("change", false)
      }

      //  Triggers clearing search.
      function handleClearSearchClick() {
        clearSearch()
      }

      //  Reinitialize for new path based on crumb.
      function handleCrumbClick(index) {
        clearSearch()
        clearSelectedItem()

        if (index === 0) {
          emitSetPath("")
        } else {
          emitSetPath(model.pathCrumbHeads.slice(1, index + 1).join("/") + "/")
        }
      }

      //  Sets selected item based on 'folder'.
      function handleFolderClick(folder) {
        model.selectedItem = {folder: folder}
      }

      //  Reinitialize for new path based on folder.
      function handleFolderDoubleClick(folder) {
        clearSearch()
        clearSelectedItem()

        if (model.pathCrumbTail === ".") {
          emitSetPath(folder + "/")
        } else {
          emitSetPath(model.pathCrumbHeads.slice(1).concat([model.pathCrumbTail, folder]).join("/") + "/")
        }
      }

      //  Sets selected item based on 'file'.
      function handleFileClick(file) {
        model.selectedItem = {file: file}
      }

      //  Manages clearing modal action.
      function handleClearFooterClick() {
        context.emit("clear")
        closeModal()
      }

      //  Manages canceling modal action.
      function handleCancelFooterClick() {
        closeModal()
      }

      //  Manages selecting modal action.
      function handleSelectFooterClick() {
        let path = model.pathCrumbHeads.slice(1).concat([model.pathCrumbTail]).join("/") + "/"

        let selection = model.selectedItem[Object.keys(model.selectedItem)[0]]
        //  Folder selection ends with '/'
        if (Object.keys(model.selectedItem)[0] === "folder") {
          selection += "/"
        }

        context.emit("select", {path: path, selection: selection})
        closeModal()
      }

      return {
        model,
        showFiles,
        showFolders,
        foldersListClass,
        filesListClass,
        handleClearSearchClick,
        handleCrumbClick,
        handleFolderClick,
        handleFolderDoubleClick,
        handleFileClick,
        handleClearFooterClick,
        handleCancelFooterClick,
        handleFolderDoubleClick,
        handleSelectFooterClick
      }
    }
  }
</script>
