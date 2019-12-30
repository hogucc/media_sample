<template>
  <div class="container">
    <div class="row">
      <div class="col s7 m7" v-for="(post, index) in posts" v-bind:key="post.id">
        <div class="card">
          <div class="card-image">
            <img :src="post.image.url"/>
          </div>
          <div class="card-content" v-on:click="toggleShowPost(index)">
            <div class="card-title">
              {{post.title}}
            </div>
            <div class="card-more">
              <div v-if="show[index]">
                <font-awesome-icon icon="angle-up" size="lg"/>
              </div>
              <div v-else>
                <font-awesome-icon icon="angle-down" size="lg"/>
              </div>
            </div>
          </div>
          <div class="card-detail" v-show="show[index]">
            {{post.content}}
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import axios from 'axios'

  export default {
    name: 'PostHome',
    data: function() {
      return{
        posts: [],
        show: {}
      }
    },
    mounted: function(){
      this.fetchPosts();
    },
    methods: {
      fetchPosts(){
        axios.get(`api/v1/posts`).then(res => {
          for(var i = 0; i < res.data.posts.length; i++) {
            this.posts.push(res.data.posts[i]);
          }
        }, (error) => {
          console.log(error);
        });
      },
      toggleShowPost(key){
        this.$set(this.show , key, !this.show[key])
      }
    }
  }
</script>

<style scoped></style>