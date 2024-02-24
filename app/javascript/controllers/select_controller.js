import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "state", "city" ];
  static values = { url: String }

  load_option = (tag, values) => {
    values.forEach((value) => {
      const option = document.createElement("option");
      option.value = value;
      option.text = value;
      tag.appendChild(option);
    });
  }

  state_change = () => {
    console.log("state_change");

    if (this.stateTarget.value != "") {
      this.cityTarget.length = 0;
      const url = new URL(this.urlValue)
      url.searchParams.append("state", this.stateTarget.value)
      fetch(url)
      .then(response => response.json())
      .then((data) => this.load_option(this.cityTarget, data))
      .catch(() => [])
    }
  }
}
