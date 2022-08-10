import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import Swal from 'sweetalert2/dist/sweetalert2.min.js'
window.Swal = Swal;

Rails.start()
require("jquery")
global.toastr = require("toastr")
require("admin/popper.min")
require("admin/perfect-scrollbar.min")
require("admin/bootstrap.min")
require("admin/sweetalert2.min")
//= require i18n
//= require i18n.js
//= require i18n/translations
require("admin/pcoded.min")
require("admin/index.min")
require("admin/author")

Turbolinks.start()
ActiveStorage.start()
