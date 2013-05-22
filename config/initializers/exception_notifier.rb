if Rails.env.production?
  Rails.application.config.middleware.use ExceptionNotifier,
  email: {
    email_prefix: "#{ENV['THEME'].downcase} Exception Notifier ",
    sender_address: %{"notifier" <errors@rails.mx>},
    exception_recipients: ENV['EMAIL_NOTIFIER'].split(',')
  }
end