express   = require 'express'
mongoose  = require 'mongoose'
_         = require 'lodash'
moment    = require 'moment'

exports.get = (req, res, next) ->
  _v = req.query._v
  version = req.query.version
  if version is '2'
    etps = 
      _v: 1
      list: [
        name: 'Межотраслевая торговая система "Фабрикант"'
        url: 'fabrikant.ru'
      ,
        name: 'Российский аукционный дом'
        url: 'lot-online.ru'
      ,
        name: 'ЗАО "Сбербанк-АСТ"'
        url: 'utp.sberbank-ast.ru/bankruptcy'
      ,
        name: 'ЭТП "Пром-Консалтинг"'
        url: 'promkonsalt.ru'
      ,
        name: 'ЭТП "МФБ"'
        url: 'etp.mse.ru'
      ,
        name: 'ЭТП "Аукционы Дальнего Востока"'
        url: 'torgidv.ru'
      ,
        name: 'ЭТП "МЭТС"'
        url: 'm-ets.ru'
      ,
        name: 'ЭТП "Аукционы Сибири"'
        url: 'ausib.ru'
      ,
        name: 'ЭТП "Аукционный тендерный центр"'
        url: 'atctrade.ru'
      ,
        name: 'ЭТП "ВТБ-Центр"'
        url: 'vtb-center.ru'
      ,
        name: 'ЭТП "Новые Информацонные Сервисы"'
        url: 'nistp.ru'
      ,
        name: 'ЭТП "Аукцион-центр"'
        url: 'aukcioncenter.ru'
      ,
        name: 'ЭТП "Система Электронных Торгов Имуществом"'
        url: 'seltim.ru'
      ,
        name: 'ЭТП "Профит"'
        url: 'etp-profit.ru'
      ,
        name: 'ЭТП "А-КОСТА info"'
        url: 'akosta.info'
      ,
        name: 'ЭТП "Поволжский Аукционный Дом"'
        url: 'auction63.ru'
      ,
        name: 'Всероссийская Электронная Торговая Площадка'
        url: 'торговая-площадка-вэтп.рф'
      ,
        name: 'Электронный капитал'
        url: 'eksystems.ru'
      ,
        name: 'Региональная торговая площадка'
        url: 'regtorg.com'
      ,
        name: 'ЭТП "Банкротство"'
        url: 'etp-bankrotstvo.ru'
      ,
        name: 'Открытая торговая площадка'
        url: 'opentp.ru'
      ,
        name: 'ЭТП "Регион"'
        url: 'gloriaservice.ru'
      ,
        name: 'ЭТП "UralBidIn"'
        url: 'uralbidin.ru'
      ,
        name: 'ЭТП "Property Trade"'
        url: 'propertytrade.ru'
      ,
        name: 'ЭТП "Агенда"'
        url: 'etp-agenda.ru'
      ,
        name: 'ЭТП "Мета-Инвест"'
        url: 'meta-invest.ru'
      ,
        name: 'Уральская ЭТП'
        url: 'etpu.ru'
      ,
        name: 'ЭТП "ТендерСтандарт"'
        url: 'tenderstandart.ru'
      ,
        name: 'ЭТП "ELECTRO-TORGI.RU"'
        url: 'bankrupt.electro-torgi.ru'
      ,
        name: 'ЭТП "Арбитат"'
        url: 'arbitat.ru'
      ,
        name: 'Южная ЭТП'
        url: 'torgibankrot.ru'
      ,
        name: 'Балтийская ЭТП'
        url: 'bepspb.ru'
      ,
        name: 'ЭТП "Альфалот"'
        url: 'alfalot.ru'
      ,
        name: 'Объединенная торговая площадка'
        url: 'utpl.ru'
      ,
        name: 'ЭТП "Вердиктъ"'
        url: 'vertrades.ru'
      ,
        name: 'ЭТП "KARTOTEKA.RU"'
        url: 'etp.kartoteka.ru'
      ,
        name: 'Электронная площадка Центра реализации'
        url: 'centerr.ru'
      ,
        name: 'ЭТП "uTender"'
        url: 'utender.ru'
      ,
        name: 'Электронная площадка №1'
        url: 'etp1.ru'
      ,
        name: 'ЭТП "ТЕНДЕР ГАРАНТ"'
        url: 'tendergarant.com'
      ]
#    if _v < etps?._v or not _v?
    res.status(200).json etps
#    else
#      res.status(304).send()
  else
    mongoose.connection.collection('etps').findOne { $query: {}, $orderby: { '_v' : -1 } , $limit: 1}, (err, etps) ->
      if _v < etps?._v or not _v?
        res.status(200).json etps
      else
        res.status(304).send()
