<template>
  <div class="card">
    <div class="card-header text-white bg-dark">
      <strong>
        Users:
      </strong>
    </div>
    <div class="card-body">
      <div v-for="user in userPresences">
        <strong class="text-dark">
          {{ user }}
          <span v-if="userIsControllingUser(user)">
            <span v-if="controllingClient || !sameUser(user)" key="solid">
              <i  class="fas fa-star fa-fw text-warning"></i>
            </span>
            <span v-else key="outline">
              <i class="far fa-star fa-fw text-warning"></i>
            </span>
          </span>
        </strong>
      </div>
    </div>
  </div>
</template>

<script>
  import {Presence} from "phoenix"
  import clientID from "../../client-id"

  export default {
    props: {
      printClientChannel: Object
    },
    data () {
      return {
        username: "",
        presences: {},
        printClientPresence: {},
        userPresences: {}
      }
    },
    computed: {
      controllingClient () {
        return clientID == this.printClientPresence.controlling_client_id
      }
    },
    watch: {
      printClientChannel (channel) {
        if (channel != null) {
          channel.push("request:username", {})
            .receive("ok", message => this.username = message.client_username)

          channel.on("presence_state", state => {
            this.presences = Presence.syncState(this.presences, state)
            this.retrievePrintClientPresence()
            this.retrieveUserPresences()
          })

          channel.on("presence_diff", diff => {
            this.presences = Presence.syncDiff(this.presences, diff)
            this.retrievePrintClientPresence()
            this.retrieveUserPresences()
          })
        } else {
          this.presences = {}
          this.username = ""
          this.printClientPresence = {}
          this.userPresences = {}
        }
      },
    },
    methods: {
      retrievePrintClientPresence() {
        let printClientMeta = Presence.list(this.presences, (id, {metas: metas}) => {
          if (id.slice(0, 12) == "print_client") {
            return {id: id, metas: metas}
          } else {
            return []
          }
        }).filter(item => !Array.isArray(item))[0]["metas"][0]

        this.printClientPresence = {controlling_client_id: printClientMeta.controlling_client_id, controlling_client_username: printClientMeta.controlling_client_username}
      },
      retrieveUserPresences() {
        let userPresences = Presence.list(this.presences, (id, {metas: metas}) => {
          if (id.slice(0, 4) == "user") {
            return metas[0].username
          } else {
            return []
          }
        }).filter(item => !Array.isArray(item))

        this.userPresences = userPresences
      },
      userIsControllingUser(user) {
        return user == this.printClientPresence.controlling_client_username
      },
      sameUser(user) {
        return user == this.username
      }
    }
  }
</script>
