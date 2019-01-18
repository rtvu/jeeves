<template>
  <form>
    <h1 class="text-center">Request Manager</h1>

    <div class="form-group">
      <label>Description:</label>
      <resizable-textarea
        class="form-control"
        v-model="request.description"
        placeholder="Request Description">
      </resizable-textarea>
    </div>

    <div class="form-group">
      <label>Notes:</label>
      <resizable-textarea
        class="form-control"
        v-model="request.notes"
        placeholder="Request Notes">
      </resizable-textarea>
    </div>

    <div class="form-group">
      <label>Comments:</label>
      <resizable-textarea
        class="form-control"
        v-model="request.comments"
        placeholder="Request Comments">
      </resizable-textarea>
    </div>

    <div class="form-group">
      <ul class="list-group">
        <label>Jobs Queue:</label>
        <draggable v-model="request.queue">
          <li
            class="list-group-item"

            v-for="item in request.queue"
            :class="{ active : isJobSelected(item.id) }"
            :key="item.id"
            @click="jobClicked(item.id)">
              <template v-if="isJobSelected(item.id)">
                <div v-for="(value, key) in item.job">{{ key.charAt(0).toUpperCase() + key.slice(1) + ": " + value }}</div>
              </template>
              <div v-else>{{"Description: " + item.job.description}}</div>
          </li>
        </draggable>
      </ul>
    </div>
    {{ request }}
  </form>
</template>

<script>
  import resizableTextarea from "./utilities/resizable-textarea"

  export default {
    components: {
      "resizable-textarea": resizableTextarea
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
        selectedJob: null
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
      }
    }
  }
</script>
