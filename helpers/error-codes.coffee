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

  strange_error:
    code: 666
    message: 'Странная ошибка'


module.exports = errors
