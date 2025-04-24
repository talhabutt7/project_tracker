// import { Controller } from "@hotwired/stimulus"
//
// export default class extends Controller {
//     connect() {
//         document.documentElement.classList.add("overflow-y-hidden")
//         const focusEl = this.element.querySelector("[autofocus]")
//         if (focusEl) focusEl.focus()
//     }
//
//     disconnect() {
//         document.documentElement.classList.remove("overflow-y-hidden")
//     }
//
//     close(event) {
//         event.preventDefault()
//         this.element.closest("turbo-frame").remove()
//     }
// }


import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        document.documentElement.classList.add("overflow-y-hidden")
        const focusEl = this.element.querySelector("[autofocus]")
        if (focusEl) focusEl.focus()
    }

    disconnect() {
        document.documentElement.classList.remove("overflow-y-hidden")
    }

    close(event) {
        event.preventDefault()
        this.element.closest("turbo-frame").remove()
    }
}
