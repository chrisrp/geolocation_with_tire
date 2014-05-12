require 'rubygems'
require 'tire'
require 'yajl/json_gem'

pin = { lat: -23.606551298117356, lon: -46.53403570235241 }

s = Tire.search 'my_index', type: 'endereco' do

			sort { by _geo_distance: { localizacao: pin, order: 'desc', unit: 'km' } }
      query { all }
      filter :geo_distance, localizacao: pin,  distance: '4km'
    end

s.results.each do |document|
	puts "#{document.id} - #{document.nome_rua}"
end

# puts s.to_curl