# frozen_string_literal: true

# Подключаем нужные библиотеки
require 'net/http'
require 'rexml/document'
require 'date'
# Подключаем класс MeteoserviceForecast
require_relative 'lib/meteoservice_forecast'

CITIES = {
  37 => 'Москва',
  69 => 'Санкт-Петербург',
  99 => 'Новосибирск',
  59 => 'Пермь',
  115 => 'Орел',
  121 => 'Чита',
  141 => 'Братск',
  199 => 'Краснодар',
  54 => 'Новороссийск'
}.freeze

# Спрашиваем у пользователя, какой город ему нужен
puts 'Погоду для какого города Вы хотите узнать?'
CITIES.each { |k, v| puts "#{k} ==> #{v}" }

city_id = gets.chomp

# Сформировали адрес запроса
uri = URI.parse("https://xml.meteoservice.ru/export/gismeteo/point/#{city_id}.xml")

response = Net::HTTP.get_response(uri)
doc = REXML::Document.new(response.body)

city_name = URI.decode_www_form_component(doc.root.elements['REPORT/TOWN'].attributes['sname'])

# Достаем все XML-теги <FORECAST> внутри тега <TOWN> и преобразуем их в массив
forecast_nodes = doc.root.elements['REPORT/TOWN'].elements.to_a

# Выводим название города и все прогнозы по порядку
puts city_name
puts

forecast_nodes.each do |node|
  puts MeteoserviceForecast.from_xml(node)
  puts
end
