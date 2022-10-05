namespace :send_mail do
  desc "send mail report monthly to admin"
  task report_monthly: :environment do
    ReportMailer.report_monthly.deliver_later
  end
end
