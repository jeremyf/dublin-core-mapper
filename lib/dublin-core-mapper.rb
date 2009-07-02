module DublinCoreMapper
  ATTRIBUTES = ['title', 'subject', 'description', 'type',
    'source', 'relation', 'coverage', 'creator',
    'publisher', 'contributor', 'rights', 'date',
    'format', 'identifier', 'language', 'audience',
    'provenance', 'rights_holder', 'instructional_method',
    'accrual_method', 'accrual_periodicity', 'accrual_policy'
  ]
  def self.register(&block)
    Proxy.new(&block)
  end

  class Proxy
    def initialize(&block)
      @elements = []
      yield(self)
    end
    
    def to_html_header
      @elements.inject([]) do |mem, (key, value)|
        mem << %(<meta name="DCTERMS.#{key}" content="#{value}" />)
      end.join("\n")
    end

    ATTRIBUTES.each do |attrib|
      define_method(attrib) do |*args|
        args.any? ? register(attrib, *args) : self[attrib]
      end
    end

    def [](key)
      @elements.inject([]){|mem, element| element[0].to_s == key.to_s ? mem << element[1] : mem }
    end

    def each
      @elements.each {|element| yield(element) }
    end

    private
    def register(element, value)
      @elements.push([element, value]) unless value.nil? || value.to_s == ''
    end
  end
end
