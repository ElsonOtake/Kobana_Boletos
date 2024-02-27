import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "state", "city" ];
  static values = { url: String }

  load_option = (values) => {
    values.forEach((value) => {
      const option = document.createElement("option");
      option.value = value;
      option.text = value;
      this.cityTarget.appendChild(option);
    });
  }

  clear_options = () => {
    let child = this.cityTarget.lastElementChild;
    while (child) {
      this.cityTarget.removeChild(child);
      child = this.cityTarget.lastElementChild;
    };
  }

  add_prompt = () => {
    if (this.cityTarget.childElementCount == 0) {
      const prompt = document.createElement("option");
      prompt.innerText = "Selecione o estado";
      this.cityTarget.appendChild(prompt);
    }
  }

  state_change = () => {
    this.clear_options();
    if (this.stateTarget.value != "") {
      const url = new URL(this.urlValue)
      url.searchParams.append("state", this.stateTarget.value)
      fetch(url)
      .then(response => response.json())
      .then((data) => this.load_option(data))
      .catch(() => [])
    } else {
      this.add_prompt();
    };
  }
}
