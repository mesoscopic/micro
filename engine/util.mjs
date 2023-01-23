const util = {
  uuid(){
    return ([1e7]+-1e3+-4e3+-8e3+-1e11).replace(/[018]/g, c =>
      (c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4).toString(16)
    );
  },
  unibin: {
    encode(string){
      const codeUnits = new Uint16Array(string.length);
      for (let i = 0; i < codeUnits.length; i++) {
        codeUnits[i] = string.charCodeAt(i);
      }
      return btoa(String.fromCharCode(...new Uint8Array(codeUnits.buffer)));
    },
    decode(binary){
      const bin = atob(binary);
      const bytes = new Uint8Array(bin.length);
      for (let i = 0; i < bytes.length; i++) {
        bytes[i] = bin.charCodeAt(i);
      }
      return String.fromCharCode(...new Uint16Array(bytes.buffer));
    }
  },
  download(name, data){
    let file = new File([data], name+'.microsave', {
      type: "text/plain"
    });
    let url = URL.createObjectURL(file);
    let a = $(`<a href="${url}" download="${file.name}"></a>`).appendTo('body')[0]
    a.click();
    $(a).remove();
    URL.revokeObjectURL(url);
  },
  getSave(id){
    //Returns an array containing the save header and its file
    let saves = JSON.parse(localStorage.getItem('micro__saves') || '[]');
    let save = saves.filter((e)=>e.id==id);
    let file = JSON.parse(localStorage.getItem('micro__'+save.id) || '{}');
    return [save, file];
  }
}

export default util;