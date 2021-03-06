errors =
  email_exists:
    code: 100
    message: 'email занят'

  auth_fail_credentials:
    code: 101
    message: 'Неверная комбинация логин/пароль'

  max_favourite_lots:
    code: 102
    message: 'Достигнут предел количества "моих лотов"'

  auth_fail_social:
    code: 103
    message: 'Данный аккаунт социальной сети не зарегистрирован в программе'

  auth_fail_social_exists:
    code: 104
    message: 'Это устройство уже зарегистрировано в системе'

  license_not_found:
    code: 105
    message: 'Лицензии с таким кодом не существует'

  purchase_completed:
    code: 106
    message: 'Эта покупка уже совершена ранее'

  invalid_signature:
    code: 107
    message: 'Неправильная сигнатура покупки'

  refer_empty_email:
    code: 108
    message: 'Не указан email'

  strange_error:
    code: 666
    message: 'Странная ошибка'


module.exports = errors
