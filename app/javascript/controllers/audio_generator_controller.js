import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "button", "error", "history"]

  connect() {
    this.pollIntervals = {}
    this.startInitialPolling()
  }
  
  startInitialPolling() {
      // Find any processing items and start polling for them
      const processingItems = this.historyTarget.querySelectorAll('[id^="voice_generation_"]')
      processingItems.forEach(item => {
          if (item.querySelector('.animate-pulse')) {
             const id = item.id.replace('voice_generation_', '')
             this.pollStatus(id, item)
          }
      })
  }

  async submit(event) {
    event.preventDefault()
    
    const text = this.inputTarget.value.trim()
    if (!text) return

    this.toggleLoading(true)
    this.errorTarget.classList.add('hidden')
    this.errorTarget.textContent = ''

    try {
      const csrfToken = document.querySelector('meta[name="csrf-token"]').content

      const response = await fetch('/api/v1/voice_generations', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken
        },
        body: JSON.stringify({ voice_generation: { text: text } })
      })

      if (!response.ok) throw new Error('Generation failed')

      const data = await response.json()
      
      // Simulate adding to history immediately (or fetch partial)
      // For simplicity, we reload the page or fetch the updated list. 
      // Better: Append a pending item.
      
      // Reloading via Turbo would be easiest, but let's just refresh for now or fetch the new partial
      location.reload() // Simple way to show the new pending state
      
    } catch (error) {
      this.errorTarget.textContent = error.message || "Something went wrong. Please try again."
      this.errorTarget.classList.remove('hidden')
      this.toggleLoading(false)
    }
  }

  toggleLoading(isLoading) {
    if (isLoading) {
      this.buttonTarget.setAttribute('disabled', 'disabled')
      this.buttonTarget.setAttribute('data-loading', 'true')
    } else {
      this.buttonTarget.removeAttribute('disabled')
      this.buttonTarget.removeAttribute('data-loading')
    }
  }

  pollStatus(id, element) {
    if (this.pollIntervals[id]) return

    this.pollIntervals[id] = setInterval(async () => {
      try {
        const response = await fetch(`/api/v1/voice_generations/${id}`)
        if (!response.ok) return

        const data = await response.json()
        if (data.status === 'completed' || data.status === 'failed') {
          clearInterval(this.pollIntervals[id])
          delete this.pollIntervals[id]
          location.reload() // Update UI to show audio player
        }
      } catch (e) {
        console.error("Polling error", e)
      }
    }, 2000)
  }
  
  disconnect() {
      Object.values(this.pollIntervals).forEach(interval => clearInterval(interval))
  }
}
