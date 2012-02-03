class ErrorNotifier < ActionMailer::Base
  default from: "Sam Ruby <depot@example.com>"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.error_notifier.errored.subject
  #
  def errored(error)
    @greeting = "Hi"
   @error = error

    mail to: "dave@example.org", :subject => 'App Errored'
  end
end

