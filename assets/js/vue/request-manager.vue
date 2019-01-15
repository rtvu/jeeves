<template>
  <form>
    <h1 class="text-center">Request Manager</h1>

    <div class="form-group">
      <label>Description:</label>
      <resizable-textarea
        class="form-control"
        v-model="request.requestDescription"
        placeholder="Request Description">
      </resizable-textarea>
    </div>

    <div class="form-group">
      <label>Notes:</label>
      <resizable-textarea
        class="form-control"
        v-model="request.requestNotes"
        placeholder="Request Notes">
      </resizable-textarea>
    </div>

    <div class="form-group">
      <label>Comments:</label>
      <resizable-textarea
        class="form-control"
        v-model="request.requestComments"
        placeholder="Request Comments">
      </resizable-textarea>
    </div>

    <div class="form-group">
      <ul class="list-group">
        <label>Jobs Queue</label>
        <draggable v-model="request.jobsQueue">
          <li
            class="list-group-item"

            v-for="job in request.jobsQueue"
            :class="{ active : isSelected(job) }"
            :key="job"
            @click="handleClick(job)">
              <div>{{job}}</div>
              <div>{{job}}</div>
          </li>
        </draggable>
      </ul>
    </div>
    {{ request }}
  </form>
</template>

<script>
  export default {
    props: {
    },
    data () {
      return {
        request: {
          requestDescription: "",
          requestNotes: "",
          requestComments: "",
          jobsQueue: ["a", "b", "c"],
          selectedJob: null
        }
        // request: {
        //   "Request Description": "test",
        //   "Request Notes": "",
        //   "Request Comments": "",
        //   "Jobs Queue": [
        //     {
        //       "Job Comments": "",
        //       "Settings": "",
        //       "Configuration File": "",
        //       "Copies": ""
        //     }
        //   ]
        // },
        // message: "test"
      }
    },
    computed: {
    },
    created () {
    },
    methods: {
      isSelected (selection) {
        return selection == this.request.selectedJob
      },
      handleClick (selection) {
        if (this.request.selectedJob == selection) {
          this.request.selectedJob = null
        } else {
          this.request.selectedJob = selection
        }
      }
    }
  }
</script>
