import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="urls"
export default class extends Controller {
  static targets = ["urlsTable", "successMessage"]

  connect() {
    console.log("UrlsController connected");
  }

  // This method will be called when the Turbo Stream updates are received
  refreshTable(event) {
    const detail = event.detail;

    // Assuming the Turbo Stream response includes HTML for the table
    if (detail && detail.result) {
      this.urlsTableTarget.innerHTML = detail.result.urls_table;
      this.successMessageTarget.innerHTML = `
        Short URL created successfully! Your Short URL: <a href="${detail.result.short_url}" target="_blank">${detail.result.short_url}</a>, 
        Original URL: ${detail.result.target_url}, 
        Title: ${detail.result.title}
      `;
      this.successMessageTarget.style.display = "block";
    }
  }
}
