require 'rubygems'
require 'tire'
require 'yajl/json_gem'


enderecos = [
	{ type: 'endereco', id: 1, nome_rua: 'rua alocasias',        bairro: 'vila industrial', cidade: 'São Paulo', localizacao: { lat: -23.607212297754483, lon: -46.53627189982217 } },
	{ type: 'endereco', id: 2, nome_rua: 'rua fava de lobo',     bairro: 'jd guairaca', cidade: 'São Paulo',     localizacao: { lat: -23.60308009766809,  lon: -46.53976250148844 } },
	{ type: 'endereco', id: 3, nome_rua: 'rua guararapes',       bairro: 'berrini', cidade: 'São Paulo',         localizacao: { lat: -23.602695400481668, lon: -46.69454550195951 } },
	{ type: 'endereco', id: 4, nome_rua: 'rua flavio tambelini', bairro: 'vila industrial', cidade: 'São Paulo', localizacao: { lat: -23.609984600496315, lon: -46.50731249770615 } }
]

begin
	Tire.index 'my_index' do
		delete

		create :mappings => {
		  :endereco => {
		    :properties => {
		    	:id        => { :type => 'string', :index => 'not_analyzed', :include_in_all => false },
		      :nome_rua  => { :type => 'string', :boost => 2.0,            :analyzer => 'snowball' },
		      :bairro    => { :type => 'string', :analyzer => 'snowball'                           },
		      :cidade    => { :type => 'string', :analyzer => 'snowball'                           },
		      :localizacao   => { :type => 'geo_point', lat_lon: true, geohash: true }
		    }
		  }
		}

		import enderecos
		refresh
	end
rescue => e
	puts "passsou aqui"
	puts e.message
end
