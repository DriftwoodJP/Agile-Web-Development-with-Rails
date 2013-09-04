class SystemNotifier < ActionMailer::Base
  default from: "system@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.system_notifier.error_occured.subject
  #
  def error_occured(error)
    @error = error
    mail to: "Sam Ruby <depot@example.com>", subject: "Depot App Error Incident"
  end
end
