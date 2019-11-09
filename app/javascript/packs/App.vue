<template>
  <div class="container js-postsIndex">
  <div class="row">
    <div class="col s7 m7" v-for="post in posts">
      <div class="card">
        <div class="card-image">
          {{post.image.to_s}}
        </div>
        <div class="card-content">
          <span class="card-title" v-on:click="setPostInfo(post.id)">
            <a id="card-title-link" href="#">{{post.title}}</a>
          </span>
        </div>
      </div>
    </div>
  </div>
  <div class="row" v-show="postInfoBool">
    <div class="col s12 m12">
      <div class="card blue-grey darken-1">
        <div class="card-content white-text">
          <div class="card-title">
            {{ postInfo.title }}
          </div>
          <div class="detail">
            {{ postInfo.content }}
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</template>

<script>
  import Vue from 'vue/dist/vue.esm'
  import axios from 'axios'

  export default {
    name: 'PostHome',
    data: function () {
      return {
        postInfo: {},
        postInfoBool: false,
        posts: [],
      }
    },
    mounted: function(){
      this.fetchPosts();
    },
    methods: {
      fetchPosts() {
        axios.get(`api/v1/posts/${id}.json`).then(res => {
          for(var i = 0; i < res.data.posts.length; i++) {
            this.books.push(res.data.books[i]);
          }
        }, (error) => {
          console.log(error);
        });
      },
      setPostInfo(id){
        axios.get(`api/v1/posts/${id}.json`).then(res => {
          this.postInfo = res.data;
          this.postInfoBool = true;
        });
      }
    }
  }
</script>

<style scoped></style>