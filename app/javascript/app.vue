<template>
  <div id="app">
    <draggable class="board drag-area" v-model="lists" @end="listMove" :options="{group: 'lists'}">
      <template v-for="(item, index) in lists">
        <div :key="index" class="list">
          <h4>{{item.name}}</h4>
          <hr>
          <draggable v-model="item.cards" :options="{group: 'cards'}" @change="cardMove" class="drag-area">
            <template v-for="(card, index) in item.cards">
              <div :key="index" class="card card-body mb-3">
                <h6>{{card.name}}</h6>
              </div>
            </template>
          </draggable>
          
          <textarea v-model="form[item.id]" class="form-control mb-1" placeholder="Add new card"></textarea>
          <button @click="handleClick(item.id)" class="btn btn-primary">Add</button>
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
    cardMove(e) {
      console.log(e);
      let evt = e.added || e.moved;
      if (evt == undefined) { return }

      // de esta manera estamos buscando el id de la lista de donde se ha movido la card
      const list_index = this.lists.findIndex(list => {
        return list.cards.find(card => {
          return card.id == evt.element.id;
        })
      })

      let data = new FormData;
      data.append("card[list_id]", this.lists[list_index].id);
      data.append("card[position]", evt.newIndex + 1);

      Rails.ajax({
        url: `/cards/${evt.element.id}/move`,
        type: "PATCH",
        data: data,
        dataType: "json"
      })
    },
    listMove(e) {
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
  .board {
    overflow-x: auto;
    white-space: nowrap;
  }

  .list {
    background: #E2E4E6;
    border-radius: 3px;
    padding: 10px;
    display: inline-block;
    vertical-align: top;
    margin-right: 20px;
    width: 270px;
  }

  .drag-area {
    min-height: 20px;
  }
</style>
