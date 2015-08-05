module.exports = (auc) -> 
  regions =
    '10':
      'name': 'Республика Карелия'
      'code': '10'
      'gai': '10'
      'okato': '86'
      'iso': 'RU-KR'
    '11':
      'name': 'Республика Коми'
      'code': '11'
      'gai': ['11', '111']
      'okato': '87'
      'iso': 'RU-KO'
    '12':
      'name': 'Республика Марий Эл'
      'code': '12'
      'gai': '12'
      'okato': '88'
      'iso': 'RU-ME'
    '13':
      'name': 'Республика Мордовия'
      'code': '13'
      'gai': ['13', '113']
      'okato': '89'
      'iso': 'RU-MO'
    '14':
      'name': 'Республика Саха (Якутия)'
      'code': '14'
      'gai': '14'
      'okato': '98'
      'iso': 'RU-SA'
    '15':
      'name': 'Республика Северная Осетия — Алания'
      'code': '15'
      'gai': '15'
      'okato': '90'
      'iso': 'RU-SE'
    '16':
      'name': 'Республика Татарстан'
      'code': '16'
      'gai': ['16', '116']
      'okato': '92'
      'iso': 'RU-TA'
    '17':
      'name': 'Республика Тыва'
      'code': '17'
      'gai': '17'
      'okato': '93'
      'iso': 'RU-TY'
    '18':
      'name': 'Удмуртская республика'
      'code': '18'
      'gai': '18'
      'okato': '94'
      'iso': 'RU-UD'
    '19':
      'name': 'Республика Хакасия'
      'code': '19'
      'gai': '19'
      'okato': '95'
      'iso': 'RU-KK'
    '20':
      'name': 'Чеченская республика'
      'code': '20'
      'gai': '95'
      'okato': '96'
      'iso': 'RU-CE'
    '21':
      'name': 'Чувашская республика'
      'code': '21'
      'gai': ['21', '121']
      'okato': '97'
      'iso': 'RU-CU'
    '22':
      'name': 'Алтайский край'
      'code': '22'
      'gai': '22'
      'okato': '01'
      'iso': 'RU-ALT'
    '23':
      'name': 'Краснодарский край'
      'code': '23'
      'gai': ['23', '93', '123']
      'okato': '03'
      'iso': 'RU-KDA'
    '24':
      'name': 'Красноярский край'
      'code': '24'
      'gai': ['24', '124', '84']
      'okato': '04'
      'iso': 'RU-KYA'
    '25':
      'name': 'Приморский край'
      'code': '25'
      'gai': ['25', '125']
      'okato': '05'
      'iso': 'RU-PRI'
    '26':
      'name': 'Ставропольский край'
      'code': '26'
      'gai': ['26', '126']
      'okato': '07'
      'iso': 'RU-STA'
    '27':
      'name': 'Хабаровский край'
      'code': '27'
      'gai': '27'
      'okato': '08'
      'iso': 'RU-KHA'
    '28':
      'name': 'Амурская область'
      'code': '28'
      'gai': '28'
      'okato': '10'
      'iso': 'RU-AMU'
    '29':
      'name': 'Архангельская область'
      'code': '29'
      'gai': '29'
      'okato': '11'
      'iso': 'RU-ARK'
    '30':
      'name': 'Астраханская область'
      'code': '30'
      'gai': '30'
      'okato': '12'
      'iso': 'RU-AST'
    '31':
      'name': 'Белгородская область'
      'code': '31'
      'gai': '31'
      'okato': '14'
      'iso': 'RU-BEL'
    '32':
      'name': 'Брянская область'
      'code': '32'
      'gai': '32'
      'okato': '15'
      'iso': 'RU-BRY'
    '33':
      'name': 'Владимирская область'
      'code': '33'
      'gai': '33'
      'okato': '17'
      'iso': 'RU-VLA'
    '34':
      'name': 'Волгоградская область'
      'code': '34'
      'gai': ['34', '134']
      'okato': '18'
      'iso': 'RU-VGG'
    '35':
      'name': 'Вологодская область'
      'code': '35'
      'gai': '35'
      'okato': '19'
      'iso': 'RU-VLG'
    '36':
      'name': 'Воронежская область'
      'code': '36'
      'gai': ['36', '136']
      'okato': '20'
      'iso': 'RU-VOR'
    '37':
      'name': 'Ивановская область'
      'code': '37'
      'gai': '37'
      'okato': '24'
      'iso': 'RU-IVA'
    '38':
      'name': 'Иркутская область'
      'code': '38'
      'gai': ['38', '138', '85']
      'okato': '25'
      'iso': 'RU-IRK'
    '39':
      'name': 'Калининградская область'
      'code': '39'
      'gai': ['39', '91']
      'okato': '27'
      'iso': 'RU-KGD'
    '40':
      'name': 'Калужская область'
      'code': '40'
      'gai': '40'
      'okato': '29'
      'iso': 'RU-KLU'
    '42':
      'name': 'Кемеровская область'
      'code': '42'
      'gai': ['42', '142']
      'okato': '32'
      'iso': 'RU-KEM'
    '43':
      'name': 'Кировская область'
      'code': '43'
      'gai': '43'
      'okato': '33'
      'iso': 'RU-KIR'
    '44':
      'name': 'Костромская область'
      'code': '44'
      'gai': '44'
      'okato': '34'
      'iso': 'RU-KOS'
    '45':
      'name': 'Курганская область'
      'code': '45'
      'gai': '45'
      'okato': '37'
      'iso': 'RU-KGN'
    '46':
      'name': 'Курская область'
      'code': '46'
      'gai': '46'
      'okato': '38'
      'iso': 'RU-KRS'
    '47':
      'name': 'Ленинградская область'
      'code': '47'
      'gai': '47'
      'okato': '41'
      'iso': 'RU-LEN'
    '48':
      'name': 'Липецкая область'
      'code': '48'
      'gai': '48'
      'okato': '42'
      'iso': 'RU-LIP'
    '49':
      'name': 'Магаданская область'
      'code': '49'
      'gai': '49'
      'okato': '44'
      'iso': 'RU-MAG'
    '50':
      'name': 'Московская область'
      'code': '50'
      'gai': ['50', '90', '150', '190', '750']
      'okato': '46'
      'iso': 'RU-MOS'
    '51':
      'name': 'Мурманская область'
      'code': '51'
      'gai': '51'
      'okato': '47'
      'iso': 'RU-MUR'
    '52':
      'name': 'Нижегородская область'
      'code': '52'
      'gai': ['52', '152']
      'okato': '22'
      'iso': 'RU-NIZ'
    '53':
      'name': 'Новгородская область'
      'code': '53'
      'gai': '53'
      'okato': '49'
      'iso': 'RU-NGR'
    '54':
      'name': 'Новосибирская область'
      'code': '54'
      'gai': ['54', '154']
      'okato': '50'
      'iso': 'RU-NVS'
    '55':
      'name': 'Омская область'
      'code': '55'
      'gai': '55'
      'okato': '52'
      'iso': 'RU-OMS'
    '56':
      'name': 'Оренбургская область'
      'code': '56'
      'gai': '56'
      'okato': '53'
      'iso': 'RU-ORE'
    '57':
      'name': 'Орловская область'
      'code': '57'
      'gai': '57'
      'okato': '54'
      'iso': 'RU-ORL'
    '58':
      'name': 'Пензенская область'
      'code': '58'
      'gai': '58'
      'okato': '56'
      'iso': 'RU-PNZ'
    '60':
      'name': 'Псковская область'
      'code': '60'
      'gai': '60'
      'okato': '58'
      'iso': 'RU-PSK'
    '61':
      'name': 'Ростовская область'
      'code': '61'
      'gai': ['61', '161']
      'okato': '60'
      'iso': 'RU-ROS'
    '62':
      'name': 'Рязанская область'
      'code': '62'
      'gai': '62'
      'okato': '61'
      'iso': 'RU-RYA'
    '63':
      'name': 'Самарская область'
      'code': '63'
      'gai': ['63', '163']
      'okato': '36'
      'iso': 'RU-SAM'
    '64':
      'name': 'Саратовская область'
      'code': '64'
      'gai': ['64', '164']
      'okato': '63'
      'iso': 'RU-SAR'
    '65':
      'name': 'Сахалинская область'
      'code': '65'
      'gai': '65'
      'okato': '64'
      'iso': 'RU-SAK'
    '66':
      'name': 'Свердловская область'
      'code': '66'
      'gai': ['66', '96', '196']
      'okato': '65'
      'iso': 'RU-SVE'
    '67':
      'name': 'Смоленская область'
      'code': '67'
      'gai': '67'
      'okato': '66'
      'iso': 'RU-SMO'
    '68':
      'name': 'Тамбовская область'
      'code': '68'
      'gai': '68'
      'okato': '68'
      'iso': 'RU-TAM'
    '69':
      'name': 'Тверская область'
      'code': '69'
      'gai': '69'
      'okato': '28'
      'iso': 'RU-TVE'
    '70':
      'name': 'Томская область'
      'code': '70'
      'gai': '70'
      'okato': '69'
      'iso': 'RU-TOM'
    '71':
      'name': 'Тульская область'
      'code': '71'
      'gai': '71'
      'okato': '70'
      'iso': 'RU-TUL'
    '72':
      'name': 'Тюменская область'
      'code': '72'
      'gai': '72'
      'okato': '71'
      'iso': 'RU-TYU'
    '73':
      'name': 'Ульяновская область'
      'code': '73'
      'gai': ['73', '173']
      'okato': '73'
      'iso': 'RU-ULY'
    '74':
      'name': 'Челябинская область'
      'code': '74'
      'gai': ['74', '174']
      'okato': '75'
      'iso': 'RU-CHE'
    '76':
      'name': 'Ярославская область'
      'code': '76'
      'gai': '76'
      'okato': '78'
      'iso': 'RU-YAR'
    '77':
      'name': 'Москва'
      'code': '77'
      'gai': ['77', '97', '99', '177', '197', '199', '777']
      'okato': '45'
      'iso': 'RU-MOW'
    '78':
      'name': 'Санкт-Петербург'
      'code': '78'
      'gai': ['78', '98', '178']
      'okato': '40'
      'iso': 'RU-SPE'
    '79':
      'name': 'Еврейская автономная область'
      'code': '79'
      'gai': '79'
      'okato': '99'
      'iso': 'RU-YEV'
    '83':
      'name': 'Ненецкий автономный округ'
      'code': '83'
      'gai': '83'
      'okato': '11-8'
      'iso': 'RU-NEN'
    '86':
      'name': 'Ханты-Мансийский автономный округ - Югра'
      'code': '86'
      'gai': ['86', '186']
      'okato': '71-8'
      'iso': 'RU-KHM'
    '87':
      'name': 'Чукотский автономный округ'
      'code': '87'
      'gai': '87'
      'okato': '77'
      'iso': 'RU-CHU'
    '89':
      'name': 'Ямало-Ненецкий автономный округ'
      'code': '89'
      'gai': '89'
      'okato': '71-9'
      'iso': 'RU-YAN'
    '01':
      'name': 'Республика Адыгея'
      'code': '01'
      'gai': '01'
      'okato': '79'
      'iso': 'RU-AD'
    '04':
      'name': 'Республика Алтай'
      'code': '04'
      'gai': '04'
      'okato': '84'
      'iso': 'RU-AL'
    '02':
      'name': 'Республика Башкортостан'
      'code': '02'
      'gai': ['02', '102']
      'okato': '80'
      'iso': 'RU-BA'
    '03':
      'name': 'Республика Бурятия'
      'code': '03'
      'gai': '03'
      'okato': '81'
      'iso': 'RU-BU'
    '05':
      'name': 'Республика Дагестан'
      'code': '05'
      'gai': '05'
      'okato': '82'
      'iso': 'RU-DA'
    '06':
      'name': 'Республика Ингушетия'
      'code': '06'
      'gai': '06'
      'okato': '26'
      'iso': 'RU-IN'
    '07':
      'name': 'Кабардино-Балкарская республика'
      'code': '07'
      'gai': '07'
      'okato': '83'
      'iso': 'RU-KB'
    '08':
      'name': 'Республика Калмыкия'
      'code': '08'
      'gai': '08'
      'okato': '85'
      'iso': 'RU-KL'
    '09':
      'name': 'Карачаево-Черкесская республика'
      'code': '09'
      'gai': '09'
      'okato': '91'
      'iso': 'RU-KC'
    '91':
      'name': 'Республика Крым'
      'code': '91'
      'gai': '82'
      'okato': '35'
      'iso': 'RU-CR'
    '75':
      'name': 'Забайкальский край'
      'code': '75'
      'gai': ['75', '80']
      'okato': '76'
      'iso': 'RU-ZAB'
    '41':
      'name': 'Камчатский край'
      'code': '41'
      'gai': '41'
      'okato': '30'
      'iso': 'RU-KAM'
    '59':
      'name': 'Пермский край'
      'code': '59'
      'gai': ['59', '81', '159']
      'okato': '57'
      'iso': 'RU-PER'
    '92':
      'name': 'Севастополь'
      'code': '92'
      'gai': '92'
      'okato': '67'
      'iso': 'RU-SEV'

  region = null
  if auc.debtor.ogrn
    region = regions[auc.debtor.ogrn.slice(3,5)]
  if not region and auc.debtor.inn
    region = regions[auc.debtor.inn.slice(0,2)]
  if auc.owner.ogrn
    region = regions[auc.owner.ogrn.slice(3,5)]
  if not region and auc.owner.inn
    region = regions[auc.owner.inn.slice(0,2)]
  return if region then region.name else 'Не определен'
