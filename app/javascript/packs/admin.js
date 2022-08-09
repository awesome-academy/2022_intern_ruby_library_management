import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

import jquery from 'jquery';
window.jQuery = jquery;
window.$ = jquery;

import Swal from 'sweetalert2/dist/sweetalert2.min.js'
window.Swal = Swal;

Rails.start()
Turbolinks.start()
ActiveStorage.start()

global.toastr = require("toastr")
require('login/select2.min')

require("admin/popper.min")
require("admin/perfect-scrollbar.min")
require("admin/bootstrap.min")
require("admin/sweetalert2.min")
//= require i18n
//= require i18n.js
//= require i18n/translations
//= require tinymce
require("admin/pcoded.min")
require("admin/index.min")
