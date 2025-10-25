class UserMailer < ApplicationMailer
  default from: 'noreply@bookshelf.com'

  def import_report(import)
    @import = import
    @duration = import.duration ? "#{import.duration.round(2)} секунд" : "N/A"
    
    mail(
      to: @import.user_email,
      subject: "Звіт про імпорт книг - #{@import.status == 'completed' ? 'Успішно' : 'Помилка'}"
    )
  end
end
