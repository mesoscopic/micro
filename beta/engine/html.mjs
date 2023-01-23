class EditableTitle extends HTMLInputElement {
  constructor(){
    super();
    this.addEventListener('input', ()=>{
      this.setAttribute('size', (this.value.length - 1)<1?1:(this.value.length - 1))
    });
    this.classList.add('editable-title')
  }
}

const html = {
  init(){
    customElements.define("editable-title", EditableTitle, {extends: "input"});
  }
}

export default html;