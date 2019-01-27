<template>
  <form>
    <h1 class="text-center">Request Manager</h1>

    <div class="form-group">
      <label>Description:</label>
      <resizable-textarea
        class="form-control form-control-sm"
        v-model="request.description">
      </resizable-textarea>
    </div>

    <div class="form-group">
      <label>Notes:</label>
      <resizable-textarea
        class="form-control form-control-sm"
        v-model="request.notes">
      </resizable-textarea>
    </div>

    <div class="form-group">
      <label>Comments:</label>
      <resizable-textarea
        class="form-control form-control-sm"
        v-model="request.comments">
      </resizable-textarea>
    </div>



    <div class="form-group">
      <label>Jobs Queue:</label>
      <div class="row form-group">
        <div class="col">
          <tooltip-text-flex-button
            button-class="btn btn-sm btn-outline-dark btn-block"
            button-style=""

            title="Load"

            html="<i class='mx-1 far fa-folder-open fa-fw'></i>Load"
            @click="loadJobClicked">
          </tooltip-text-flex-button>
        </div>
        <div class="col">
          <tooltip-text-flex-button
            button-class="btn btn-sm btn-outline-dark btn-block"
            button-style=""

            title="New"

            html="<i class='mx-1 far fa-file fa-fw'></i>New"
            @click="newJobClicked">
          </tooltip-text-flex-button>
        </div>
        <div class="col">
          <tooltip-text-flex-button
            button-class="btn btn-sm btn-outline-dark btn-block"
            button-style=""

            title="Delete"

            html="<i class='mx-1 far fa-trash-alt fa-fw'></i>Delete"
            @click="deleteJobClicked">
          </tooltip-text-flex-button>
        </div>
        <div class="col">
          <tooltip-text-flex-button
            button-class="btn btn-sm btn-outline-dark btn-block"
            button-style=""

            title="Copy"

            html="<i class='mx-1 far fa-copy fa-fw'></i>Copy"
            @click="copyJobClicked">>
          </tooltip-text-flex-button>
        </div>
      </div>
      <ul class="list-group">
        <draggable v-model="request.queue">
          <li
            class="list-group-item py-1 px-2"

            v-for="item in request.queue"
            :class="{active : isJobSelected(item.id)}"
            :key="item.id"
            @click="jobClicked(item.id)">
              <template v-if="isJobSelected(item.id)">
                <div style="font-size: 0.875rem" v-for="(value, key) in item.job">{{ key.charAt(0).toUpperCase() + key.slice(1) + ": " + value }}</div>
              </template>
              <div style="font-size: 0.875rem" v-else>{{"Description: " + item.job.description}}</div>
          </li>
        </draggable>
      </ul>
    </div>
  </form>
</template>

<script>
  import draggable from "vuedraggable"
  import resizableTextarea from "../utilities/resizable-textarea"
  import tooltipTextFlexButton from "../utilities/tooltip-text-flex-button"

  export default {
    components: {
      "draggable": draggable,
      "resizable-textarea": resizableTextarea,
      "tooltip-text-flex-button": tooltipTextFlexButton,
    },
    props: {
      currentJob: Object
    },
    data () {
      return {
        request: {
          description: "",
          notes: "",
          comments: "",
          queue: [
            {
              id: 0,
              job: {
                description: "test test",
                comments: "",
                settings: "",
                configuration: "",
              }
            },
            {
              id: 1,
              job: {
                description: "rah rah",
                comments: "",
                settings: "",
                configuration: "",
              }
            }
          ],
        },
        selectedJob: null,
        nextID: 2
      }
    },
    computed: {
    },
    created () {
    },
    methods: {
      isJobSelected (job) {
        return job == this.selectedJob
      },
      jobClicked (job) {
        if (this.selectedJob == job) {
          this.selectedJob = null
        } else {
          this.selectedJob = job
        }
      },
      newJobClicked () {
        this.pushJob({
          description: "new job",
          comments: "",
          settings: "",
          configuration: "",
        })
      },
      deleteJobClicked () {
        this.request.queue = this.request.queue.filter(job => job.id != this.selectedJob)
      },
      copyJobClicked () {
        let copy = {}
        for (let attr in this.currentJob) {
          copy[attr] = this.currentJob[attr]
        }

        this.pushJob(copy)
      },
      loadJobClicked () {
        this.$emit("load-job", {job: this.request.queue.filter(job => job.id === this.selectedJob)[0].job})
      },
      pushJob (job) {
        this.request.queue.push({
          id: this.nextID,
          job: job
        })

        this.nextID = this.nextID + 1
      }
    }
  }
</script>
