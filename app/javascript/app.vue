<template>
  <div id="app">
    <draggable class="row drag-area" v-model="lists" @end="handleEndMove" :options="{group: 'lists'}">
      <template v-for="(item, index) in lists">
        <div :key="index" class="col">
          <h4>{{item.name}}</h4>
          <hr>
          <template v-for="(card, index) in item.cards" class="card card-body mb-3">
            <h6 :key="index">{{card.name}}</h6>
          </template>

          <div class="card card-body">
            <textarea v-model="form[item.id]" class="form-control"></textarea>
            <button @click="handleClick(item.id)" class="btn btn-primary">Add</button>
          </div>
        </div>
      </template>
    </draggable>
  </div>
</template>

<script>
import draggable from 'vuedraggable';

export default {
  components: { draggable },
  props: ["original_lists"],
  data: function () {
    return {
      form: {},
      lists: this.original_lists
    }
  },
  methods: {
    handleEndMove(e) {
      let data = new FormData;
      data.append("list[position]", e.newIndex + 1);

      Rails.ajax({
        url: `/lists/${this.lists[e.newIndex].id}/move`,
        type: "PATCH",
        data: data,
        dataType: "json"
      })
    },
    handleClick(list_id) {
      let data = new FormData;
      data.append("card[list_id]", list_id);
      data.append("card[name]", this.form[list_id])

      Rails.ajax({
        url: "/cards",
        type: "POST",
        data: data,
        dataType: "json",
        success: (data) => {
          const index = this.lists.findIndex(item => item.id === list_id);
          this.lists[index].cards.push(data);
          this.form[list_id] = undefined;
        }
      })
    }
  }
}
</script>

<style scoped>
  .drag-area {
    min-height: 20px;
  }
</style>
