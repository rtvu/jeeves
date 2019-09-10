<template>
  <b-modal
    no-close-on-esc
    no-close-on-backdrop
    hide-header-close
    size="lg"

    :visible="show"

    :title="'Select ' + resource">

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

    <div class="input-group input-group-sm p-1">
      <div class="input-group-prepend">
        <span class="input-group-text"><i class="fas fa-search fa-fw text-secondary"></i></span>
      </div>
      <input class="form-control" v-model="model.search" type="text" style="background-color: transparent;">
      <div class="input-group-append">
        <button class="btn btn-secondary" type="button" @click="handleClearSearchClick">Clear</button>
      </div>
    </div>

    <div class="p-1" style="overflow-y: auto; max-height: 50vh;">
      <div class="input-group input-group-sm" v-for="folder in showFolders">
        <div class="input-group-prepend">
          <span class="input-group-text"><i class="far fa-folder fa-fw text-info"></i></span>
        </div>
        <input type="text" :class="foldersListClass(folder)" readonly @click="handleFolderClick(folder)" @dblclick="handleFolderDoubleClick(folder)" :value="folder" style="background-color: transparent;">
      </div>

      <div class="input-group input-group-sm" v-for="file in showFiles">
        <div class="input-group-prepend">
          <span class="input-group-text"><i class="far fa-file fa-fw text-success"></i></span>
        </div>
        <input type="text" :class="filesListClass(file)" readonly @click="handleFileClick(file)" :value="file" style="background-color: transparent;">
      </div>
    </div>

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

  function filter(array, search) {
    if (search === "") {
      return array
    } else {
      return array.filter(item => item.includes(search))
    }
  }

  export default {
    model: {
      prop: "show",
      event: "change"
    },
    props: {
      resource: {
        type: String,
        default: ""
      },
      show: {
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
        pathCrumbTail,
        pathCrumbHeads
      })

      // Array
      const showFiles = computed(() => {
        if (props.type === "folders") {
          return []
        } else {
          return filter(props.files, model.search)
        }
      })

      const showFolders = computed(() => {
        return filter(props.folders, model.search)
      })

      watch(
        () => props.path,
        (path) => {
          // ("./" + path) ==> add "." to path
          // replace(/\/+$/, "") ==> remove ending "/"
          // split("/") ==> split by "/"
          let partitionedPath = ("./" + path).replace(/\/+$/, "").split("/")
          model.pathCrumbTail = partitionedPath.pop()
          model.pathCrumbHeads = partitionedPath
        }
      )

      watch(
        () => props.show,
        (show) => {
          if (show) {
            if (props.selection.slice(-1) === "/") {
              model.selectedItem = { folder: props.selection.slice(0, -1) }
            } else {
              model.selectedItem = { file: props.selection }
            }
          }
        }
      )

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

      function foldersListClass(folder) {
        if (folder === model.selectedItem.folder) {
          return ["form-control", "font-weight-bold", "text-primary"]
        } else {
          return ["form-control"]
        }
      }

      function filesListClass(file) {
        if (file === model.selectedItem.file) {
          return ["form-control", "font-weight-bold", "text-primary"]
        } else {
          return ["form-control"]
        }
      }

      function emitListPathContents(path) {
        context.emit("list-path-contents", path)
      }

      function clearSearch() {
        model.search = ""
      }

      function closeModal() {
        context.emit("change", false)
      }

      function clearSelectedItem() {
        model.selectedItem = ""
      }

      function handleClearSearchClick() {
        clearSearch()
      }

      function handleCrumbClick(index) {
        clearSearch()
        clearSelectedItem()

        if (index === 0) {
          emitListPathContents("")
        } else {
          emitListPathContents(model.pathCrumbHeads.slice(1, index + 1).join("/") + "/")
        }
      }

      function handleFolderClick(folder) {
        model.selectedItem = {folder: folder}
      }

      function handleFolderDoubleClick(folder) {
        clearSearch()
        clearSelectedItem()

        if (model.pathCrumbTail === ".") {
          emitListPathContents(folder + "/")
        } else {
          emitListPathContents(model.pathCrumbHeads.slice(1).concat([model.pathCrumbTail, folder]).join("/") + "/")
        }
      }

      function handleFileClick(file) {
        model.selectedItem = {file: file}
      }

      function handleClearFooterClick() {
        context.emit("clear")
        closeModal()
      }

      function handleCancelFooterClick() {
        closeModal()
      }

      function handleSelectFooterClick() {
        let path = model.pathCrumbHeads.slice(1).concat([model.pathCrumbTail]).join("/") + "/"

        let selection = model.selectedItem[Object.keys(model.selectedItem)[0]]
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
