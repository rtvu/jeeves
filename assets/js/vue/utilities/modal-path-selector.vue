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
        <button class="btn btn-secondary" type="button" @click="handleClearSearchButton">Clear</button>
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
  import { onMounted, reactive, watch, computed } from "@vue/composition-api"

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

      function foldersListClass(folder) {
        if (folder === model.selectedItem.folder) {
          return ["form-control", "font-weight-bold", "text-primary"]
        } else {
          return ["form-control"]
        }
      }

      function filesListClass(file) {
        if (file === model.modalSelectedItem.file) {
          return ["form-control", "font-weight-bold", "text-primary"]
        } else {
          return ["form-control"]
        }
      }





      // TODO: need to refactor out listPathContents
      function crumbClick(index) {
        if (index === 0) {
          listPathContents("")
        } else {
          listPathContents(model.modalPathCrumbHeads.slice(1, index + 1).join("/") + "/")
        }
      }



      function clickFolder(folder) {
        model.modalSelectedItem = {folder: folder}
      }


      // TODO: need to refactor out listPathContents
      function doubleClickFolder(folder) {
        if (model.modalPathCrumbTail === ".") {
          listPathContents(folder + "/")
        } else {
          listPathContents(model.modalPathCrumbHeads.slice(1).concat([model.modalPathCrumbTail, folder]).join("/") + "/")
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
        model.search = ""
      }

      onMounted(() => {




        watch(
          () => model.modalSelectedItem,
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
      })

      return {
        model,
        showFiles,
        showFolders,


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
