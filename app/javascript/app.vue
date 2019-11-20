<template>
  <div id="app">
    <draggable class="board drag-area" v-model="lists" @end="listMove" :options="{group: 'lists'}">
      <template v-for="(item, index) in lists">
        <list :key="index" :item="item" />
      </template>
    </draggable>
  </div>
</template>

<script>
import draggable from 'vuedraggable';
import list from './components/list';

export default {
  components: { draggable, list },
  props: ["original_lists"],
  data: function () {
    return {
      form: {},
      lists: this.original_lists
    }
  },
  methods: {
    listMove(e) {
      let data = new FormData;
      data.append("list[position]", e.newIndex + 1);

      Rails.ajax({
        url: `/lists/${this.lists[e.newIndex].id}/move`,
        type: "PATCH",
        data: data,
        dataType: "json"
      })
    }
  }
}
</script>

<style scoped>
  .board {
    overflow-x: auto;
    white-space: nowrap;
  }

  .drag-area {
    min-height: 20px;
  }
</style>
