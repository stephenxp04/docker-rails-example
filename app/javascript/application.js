import "@hotwired/turbo-rails"
import { Turbo } from "@hotwired/turbo-rails"

// Initialize Turbo
Turbo.session.drive = true

console.log("Application.js is loaded and running");

import "./controllers"
