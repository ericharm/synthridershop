// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require_tree .

function ready (fn) {
  if (document.readyState !== 'loading') fn()
  else document.addEventListener('DOMContentLoaded', fn)
}

function dropdown (selector) {
  var trigger = document.querySelector(selector)
  var content = document.querySelector(selector + ' + ul')
  var active = false

  function toggle () {
    active = !active
    if (active) content.classList.add('active')
    else content.classList.remove('active')
  }

  function hide () {
    if (active) toggle()
  }

  trigger.addEventListener('click', function (event) {
    event.preventDefault()
    toggle()
  })

  var body = document.querySelector('body')
  body.addEventListener('click', function (event) {
    if (event.target !== trigger) hide()
  })
}
