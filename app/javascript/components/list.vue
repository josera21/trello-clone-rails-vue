<template>
  <div class="list">
    <h4>{{item.name}}</h4>
    <hr>
    <draggable v-model="item.cards" :options="{group: 'cards'}" @change="cardMove" class="drag-area">
      <template v-for="(card, index) in item.cards">
        <div :key="index" class="card card-body mb-3">
          <h6>{{card.name}}</h6>
        </div>
      </template>
    </draggable>
    
    <a v-if="!editing" @click="startEditing">Add card</a>
    <div v-if="editing">
      <textarea v-model="form" ref="form" class="form-control mb-1" placeholder="Add new card"></textarea>
      <button @click="handleClick" class="btn btn-primary">Add</button>
      <a v-if="editing" @click="editing=false">Cancel</a>
    </div>
  </div>
</template>

<script>
import draggable from 'vuedraggable';

export default {
  components: { draggable },
  props: {
    item: {
      type: Object,
      required: true
    }
  },
  data() {
    return {
      form: "",
      editing: false
    }
  },
  methods: {
    startEditing() {
      this.editing = true;
      this.$nextTick(() => { this.$refs.form.focus() })
    },
    cardMove(e) {
      console.log(e);
      let evt = e.added || e.moved;
      if (evt == undefined) { return }

      // de esta manera estamos buscando el id de la lista de donde se ha movido la card
      const list_index = window.store.lists.findIndex(list => {
        return list.cards.find(card => {
          return card.id == evt.element.id;
        })
      })

      let data = new FormData;
      data.append("card[list_id]", window.store.lists[list_index].id);
      data.append("card[position]", evt.newIndex + 1);

      Rails.ajax({
        url: `/cards/${evt.element.id}/move`,
        type: "PATCH",
        data: data,
        dataType: "json"
      })
    },
    handleClick() {
      const list_id = this.item.id;
      let data = new FormData;
      data.append("card[list_id]", list_id);
      data.append("card[name]", this.form)

      Rails.ajax({
        url: "/cards",
        type: "POST",
        data: data,
        dataType: "json",
        success: (data) => {
          const index = window.store.lists.findIndex(item => item.id === list_id);
          window.store.lists[index].cards.push(data);
          this.form = "";
        }
      })
    }
  }
}
</script>

<style>
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