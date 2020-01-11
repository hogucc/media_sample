<template>
  <div class="section">
    <div class="container">
      <form class="col s12">
        <div class="row">
          <label class="form-label" for="article_title"><span class="new badge red badge-required" data-badge-caption="">必須</span>タイトル</label>
          <div class="input-field">
            <input placeholder="タイトルを15文字以内で入力してください" type="text" class="validate" v-model="post.title" required="required">
          </div>
        </div>
        <div class="row">
          <label class="form-label" for="post_detail"><span class="new badge red badge-required" data-badge-caption="">必須</span>内容</label>
          <div class="input-field">
            <input placeholder="内容を500文字以内で入力してください" type="text" class="validate" v-model="post.content" required="required">
          </div>
        </div>
        <div class="row">
          <label class="form-label" for="photo">写真を追加する</label>
          <div class = "file-field input-field">
            <div class = "btn">
              <span>画像を選択</span>
              <input ref="imageUploader" type="file" accept="image/*,.png,.jpg,.jpeg" v-on:change="onFileChange($event)" />
            </div>

            <div class = "file-path-wrapper">
              <input class = "file-path validate" type = "text" placeholder = "Upload file" />
            </div>
          </div>
          <label class="input-file" v-show="!uploadedImage">
            画像を選択
            <input ref="imageUploader" type="file" accept="image/*,.png,.jpg,.jpeg" v-on:change="onFileChange($event)" />
          </label>
          <div class="preview-item">
            <img
              v-show="uploadedImage"
              class="preview-item-file"
              :src="uploadedImage"
              alt=""
            />
          </div>
        </div>
        <div class="btn btn-post-create" v-on:click="createPost">投稿する</div>
      </form>
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
        img_name: '',
        post: {
          title: '',
          content: '',
          image: ''
        },
        isDrag: null,
      }
    },
    methods: {
      onFileChange(e){
        const files = e.target.files || e.dataTransfer.files;
        if(files.length > 0) {
          this.createImage(files[0]);
          this.img_name = files[0].name;
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
        this.$refs.imageUploader.value = ''
        this.uploadedImage = '';
      },
      checkDrag(event, key, status){ 
        if (status && event.dataTransfer.types == "text/plain") {
            //ファイルではなく、html要素をドラッグしてきた時は処理を中止
            return false
        }
        this.isDrag = status ? key : null
      },
      createPost: function(){
        if(!this.post.title) return;
        axios.post('/api/posts', {post: this.post}).then((res) => {
          this.$router.push({path: '/'});
        }, (error) => {
          console.log(error);
        });
      }
    }
  }
</script>
