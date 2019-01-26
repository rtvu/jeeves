<template>
  <form>
    <h1 class="text-center">Request Manager</h1>

    <div class="row form-group">
      <div class="col">
        <text-flex-button
          class="btn btn-sm btn-outline-dark btn-block"

          v-b-tooltip.hover
          title="New Job"

          html="<i class='mx-1 far fa-file fa-fw'></i>New Job"
          @click="newJobClicked">
        </text-flex-button>
      </div>
      <div class="col">
        <text-flex-button
          class="btn btn-sm btn-outline-dark btn-block"

          v-b-tooltip.hover
          title="Delete Job"

          html="<i class='mx-1 far fa-trash-alt fa-fw'></i>Delete Job"
          @click="deleteJobClicked">
        </text-flex-button>
      </div>
      <div class="col">
        <text-flex-button
          class="btn btn-sm btn-outline-dark btn-block"

          v-b-tooltip.hover
          title="Copy Job"

          html="<i class='mx-1 far fa-copy fa-fw'></i>Copy Job">
        </text-flex-button>
      </div>
    </div>

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
      <ul class="list-group">
        <label>Jobs Queue:</label>
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
    {{ request }}
  </form>
</template>

<script>
  import draggable from "vuedraggable"
  import resizableTextarea from "../utilities/resizable-textarea"
  import textFlexButton from "../utilities/text-flex-button"

  export default {
    components: {
      "draggable": draggable,
      "resizable-textarea": resizableTextarea,
      "text-flex-button": textFlexButton,
    },
    props: {
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
                copies: ""
              }
            },
            {
              id: 1,
              job: {
                description: "rah rah",
                comments: "",
                settings: "",
                configuration: "",
                copies: ""
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
        this.request.queue.push({
          id: this.nextID,
          job: {
            description: "new job",
            comments: "",
            settings: "",
            configuration: "",
            copies: ""
          }
        })

        this.nextID = this.nextID + 1
      },
      deleteJobClicked () {
        this.request.queue = this.request.queue.filter(job => job.id != this.selectedJob)
      }
    }
  }
</script>
