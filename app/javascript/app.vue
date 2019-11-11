<template>
  <div id="app">
    <p>{{ message }}</p>
    <div class="row">
      <div v-for="(item, index) in original_lists">
        <div class="col">
          <h4 :key="index + e">{{item.name}}</h4>
          <hr>
          <div v-for="(card, index) in item.cards">
            <h6 :key="index">{{card.name}}</h6>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ["original_lists"],
  data: function () {
    return {
      message: "Hello Vue!"
    }
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
