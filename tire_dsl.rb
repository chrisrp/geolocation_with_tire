require 'rubygems'
require 'tire'
require 'yajl/json_gem'

# Tire.index 'articles' do
# 	delete
# 	create

# 	store :title => 'One',   :tags => ['ruby']
#   store :title => 'Two',   :tags => ['ruby', 'python']
#   store :title => 'Three', :tags => ['java']
#   store :title => 'Four',  :tags => ['ruby', 'php']

# 	refresh	
# end

articles = [
      # { :id => '1', :type => 'article', :title => 'one',   :tags => ['ruby']           },
      # { :id => '2', :type => 'article', :title => 'two',   :tags => ['ruby', 'python'] },
      # { :id => '3', :type => 'article', :title => 'three', :tags => ['java']           },
      # { :id => '4', :type => 'article', :title => 'four',  :tags => ['ruby', 'php']    }
      { :id => '5', :type => 'article', :title => 'five',  :tags => ['ruby'],  :dev => 'chris'  }
    ]

Tire.index 'articles' do
	# delete

	create :mappings => {
	  :article => {
	    :properties => {
	      :id       => { :type => 'string', :index => 'not_analyzed', :include_in_all => false },
	      :title    => { :type => 'string', :boost => 2.0,            :analyzer => 'snowball'  },
	      :tags     => { :type => 'string', :analyzer => 'keyword'                             },
	      :dev      => { :type => 'string', :analyzer => 'keyword'                             },
	      :content  => { :type => 'string', :analyzer => 'snowball'                            }
	    }
	  }
	}

	import articles
	refresh
end

s = Tire.search 'articles' do
      query do
        string 'title:T*'
      end

      filter :terms, :tags => ['ruby']

      sort { by :title, 'desc' }

      facet 'global-tags', :global => true do
        terms :tags
      end

      facet 'current-tags' do
        terms :tags
      end
    end

puts ">>>>>>>>>>>>>> query >>>>>>>>>>>>>"
s.results.each do |document|
	puts "* #{ document.title } - [tags: #{document.tags.join(', ')}]"
end

puts ">>>>>>>>>>>>>>> global facets >>>>>>>>>>>>"
s.results.facets['global-tags']['terms'].each do |f|
	puts "#{f['term'].ljust(10)} #{f['count']}"
end

puts ">>>>>>>>> facets query >>>>>>>>>>>>>>>>>>"
s.results.facets['current-tags']['terms'].each do |f|
	puts "#{f['term'].ljust(10)} #{f['count']}"
end


s = Tire.search 'articles' do
		  query do
		    boolean do
		      should   { string 'tags:ruby' }
		      should   { string 'tags:java' }
		      must_not { string 'tags:python' }
		    end
		  end
		end

puts "------------------"

s.results.each do |f|
	puts "{f.title} - [tags: #{f.tags.join(', ')}]"
end