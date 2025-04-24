import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["select", "wrapper", "hidden"]

    connect() {
        this.selected = new Set()
    }

    add() {
        const select = this.selectTarget
        const selectedOption = select.selectedOptions[0]

        if (!selectedOption || !selectedOption.value) return

        const userId = selectedOption.value
        const userName = selectedOption.text

        if (this.selected.has(userId)) return

        this.selected.add(userId)
        selectedOption.disabled = true

        const tag = document.createElement("span")
        tag.className = "inline-flex items-center bg-gray-800 text-white px-3 py-1 rounded-full text-sm font-medium mr-2 mb-2"
        tag.innerHTML = `
      ${userName}
      <button type="button" data-id="${userId}" class="ml-2 text-white hover:text-red-500 font-bold">&times;</button>
    `
        tag.querySelector("button").addEventListener("click", (e) => this.remove(e))
        this.wrapperTarget.appendChild(tag)

        const hiddenField = document.createElement("input")
        hiddenField.type = "hidden"
        hiddenField.name = "project[assignee_ids][]"
        hiddenField.value = userId
        hiddenField.dataset.id = userId
        this.hiddenTarget.appendChild(hiddenField)

        select.selectedIndex = 0 // Reset to placeholder without breaking dropdown
    }

    remove(event) {
        const userId = event.target.dataset.id
        this.selected.delete(userId)

        this.hiddenTarget.querySelector(`input[data-id="${userId}"]`)?.remove()
        this.wrapperTarget.querySelector(`button[data-id="${userId}"]`)?.closest("span")?.remove()

        const option = this.selectTarget.querySelector(`option[value="${userId}"]`)
        if (option) option.disabled = false
    }
}
