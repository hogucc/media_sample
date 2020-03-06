<template>
  <div class="post-form">
    <div class="section">
      <div class="container">
        <form class="col s12 post-area">
          <div class="post-form-title">
            <label class="form-label" for="article_title">タイトル</label>
            <div class="input-field">
              <input placeholder="タイトルを15文字以内で入力してください" type="text" maxlength="15" class="validate" v-model="post.title">
            </div>
          </div>
          <div class="post-form-content">
            <label class="form-label" for="post_detail">内容</label>
            <div class="input-field">
              <textarea　placeholder="内容を400文字以内で入力してください" maxlength="400" class="materialize-textarea" v-model="post.content" />
            </div>
          </div>
          <div class="post-form-photo">
            <label class="form-label" for="photo">写真を追加する</label>
            <div id="preview-thumbnails">
              <div class="preview-container" v-show="uploadedImage">
                <img
                  v-show="uploadedImage"
                  class="preview-item-file"
                  :src="uploadedImage"
                  alt=""
                />
                <div class="delete-btn" v-show="canDisplayRemoveIcon" v-on:click="remove">
                  <font-awesome-icon icon="times" />
                </div>
              </div>
              <label for="image" v-show="!uploadedImage">
                <font-awesome-icon icon="plus" />
                <input id="image" ref="imageUploader" type="file" accept="image/jpeg,image/jpg,image/png" v-on:change="onFileChange($event)" />
              </label>
            </div>
          </div>
          <div class="post-form-submit">
            <div class="btn btn-post-create" v-on:click="createPost">投稿する</div>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
  import Vue from 'vue'
  import axios from 'axios';
  import VueAxiosPlugin from "../packs/plugins/vue-axios";

  Vue.use(VueAxiosPlugin, { axios: axios })

  export default {
    data: function(){
      return{
        uploadedImage: '',
        post: {
          title: '',
          content: '',
          image: ''
        },
        canDisplayRemoveIcon: false,
      }
    },
    methods: {
      onFileChange(e){
        const files = e.target.files;
        if(files.length > 0) {
          var size_in_megabytes = files[0].size/1024/1024;
          if(size_in_megabytes > 5) {
            alert('アップロードできるファイルの最大サイズは5MBです。5MB以下のファイルを選んでください。');
            return;
          }
          this.createImage(files[0]);
          this.post.image = files[0];
          this.canDisplayRemoveIcon = true;
        }
      },
      createImage(file){
        const reader = new FileReader();
        reader.onload = (e) => {
          this.uploadedImage = e.target.result;
        };
        reader.readAsDataURL(file);
      },
      remove(){
        this.$refs.imageUploader.value = '';
        this.uploadedImage = '';
        this.post.image = '';
        this.canDisplayRemoveIcon = false;
      },
      createPost: function(){
        if(!this.post.title || !this.post.content) return;

        const params = {
          'title': this.post.title,
          'content': this.post.content,
          'image': this.post.image
        }

        let formData = new FormData()

        Object.entries(params).forEach(
          ([key, value]) => formData.append(key, value)
        )

        axios.post('/api/v1/posts', formData).then((res) => {
          this.$router.push({path: '/'});
        }, (error) => {
          console.log(error);
        });
      }
    }
  }
</script>
