<template>
  <b-modal
    no-close-on-esc
    no-close-on-backdrop
    hide-header-close
    size="lg"

    :value="show"

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
    <template>
  </b-modal>
</template>

<script>
  import { reactive, watch, computed } from "@vue/composition-api"

  export default {
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
        default: "files"
      },
    },
    setup(props, context) {
      const model = reactive({
        search: "",
        selectFooterButtonDisabled: true,
        selectedItem: ""
      })

      const pathCrumbHeads = computed(() => {
        return ("./" + props.path).replace(/\/+$/, "").split("/").slice(0, -1)
      })

      const pathCrumbTail = computed(() => {
        return ("./" + props.path).replace(/\/+$/, "").split("/").pop()
      })

      const showFiles = computed(() => {
        if (model.search === "") {
          return props.files
        } else {
          return props.files.filter((file) => file.includes(model.search))
        }
      })

      const showFolders = computed(() => {
        if (model.search === "") {
          return props.folders
        } else {
          return props.folders.filter((folder) => folder.includes(model.search))
        }
      })

      watch(
        () => props.show,
        (show) => {
          if (show) {
            model.selectedItem = props.selection
          }
        }
      )

      watch(
        () => model.selectedItem,
        (selectedItem) => {
          if (selectedItem === "") {
            model.selectFooterButtonDisabled = true
          } else if ((props.type === "files") && selectedItem.hasOwnProperty("folder")) {
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
        context.emit("close")
      }

      function handleCancelFooterClick() {
        context.emit("cancel")
        context.emit("close")
      }

      function handleSelectFooterClick() {
        let path = model.pathCrumbHeads.slice(1).concat([model.pathCrumbTail]).join("/") + "/"
        let selection = model.selectedItem[Object.keys(model.modalSelectedItem)[0]]
        context.emit("select", {path: path, selection: selection})
        context.emit("close")
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
        handleFolderDoubleClick,
        handleSelectFooterClick
      }
    }
  }
</script>
