<template>
  <div class="post-form">
    <div class="section">
      <div class="container">
        <form class="col s12 post-area">
          <div class="post-form-title">
            <label class="form-label" for="article_title"><span class="new badge red badge-required" data-badge-caption="">必須</span>タイトル</label>
            <div class="input-field">
              <input placeholder="タイトルを15文字以内で入力してください" type="text" maxlength="15" class="validate" v-model="post.title" required="required">
            </div>
          </div>
          <div class="post-form-content">
            <label class="form-label" for="post_detail"><span class="new badge red badge-required" data-badge-caption="">必須</span>内容</label>
            <div class="input-field">
              <textarea　placeholder="内容を400文字以内で入力してください" maxlength="400" class="materialize-textarea" v-model="post.content" required="required" />
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
              <label for="file-upload" v-show="!uploadedImage">
                <font-awesome-icon icon="plus" />
                <input id="file-upload" ref="imageUploader" type="file" accept="image/*,.png,.jpg,.jpeg" v-on:change="onFileChange($event)" />
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
        const files = e.target.files || e.dataTransfer.files;
        if(files.length > 0) {
          if(files[0].size > 5) {
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
        this.canDisplayRemoveIcon = false;
      },
      createPost: function(){
        console.log("createPost");
        if(!this.post.title || !this.post.content) return;
        console.log(this.post.title);
        console.log(this.post.content);
        console.log(this.post.image);
        let formData = new FormData();
        formData.append('fileKey', this.post.image);
        axios.post('/api/posts', {post: this.post}).then((res) => {
          this.$router.push({path: '/'});
        }, (error) => {
          console.log(error);
        });
      }
    }
  }
</script>
