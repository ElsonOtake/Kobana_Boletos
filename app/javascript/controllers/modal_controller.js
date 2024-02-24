import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { id: { type: String, default: "modal-boleto" } };

  openModal = ($el) => {
    $el.classList.add('is-active');
  }

  closeModal = ($el) => {
    $el.classList.remove('is-active');
  }

  closeAllModals = () => {
    (document.querySelectorAll('.modal') || []).forEach(($modal) => {
      this.closeModal($modal);
    });
  }

  open = () => {
    const target = document.getElementById(this.idValue);
    this.openModal(target);
  }

  initialize = () => {
    (document.querySelectorAll('.modal-background, .modal-close, .button') || []).forEach(($close) => {
      const $target = $close.closest('.modal');
  
      $close.addEventListener('click', () => {
        this.closeModal($target);
      });
    });
  
    document.addEventListener('keydown', (event) => {
      if(event.key === "Escape") {
        this.closeAllModals();
      }
    });
  }
}