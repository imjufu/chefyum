module Ciqual
  class XmlParser
    attr_reader :foods

    SOURCE = "ciqual.anses"

    NUTRITION_FACTS_MAPPINGS = {
      "328" => :energy,
      "25003" => :proteins,
      "31000" => :carbohydrates,
      "40000" => :lipids,
      "32000" => :sugars,
      "40302" => :saturated_fatty_acids,
      "10004" => :salt,
      "34100" => :fibers
    }

    def initialize(dirpath)
      @dirpath = Pathname.new(dirpath)
      @logger = Rails.logger
      @foods = {}
    end

    def parse!
      files = {
        alim_file: nil,
        compo_file: nil
      }

      Dir.glob(@dirpath.join("*.xml")).each do |filepath|
        filename = filepath.remove("#{@dirpath}/")
        if filename.match?(/^alim_\d/)
          files[:alim_file] = filepath
        elsif filename.match?(/^compo_/)
          files[:compo_file] = filepath
        end
      end

      parse_alim_file(files[:alim_file])
      parse_compo_file(files[:compo_file])

      true
    end

    protected

    def parse_alim_file(filepath)
      @logger.debug "Parsing alim file…"
      @foods = {}
      doc = Nokogiri.XML(File.open(filepath, "r"))
      ciqual_alims = doc.xpath("//ALIM")
      total = ciqual_alims.length
      ciqual_alims.each_with_index do |ciqual_alim, i|
        @logger.debug "-> alim: #{i+1} / #{total}"
        code = label = nil
        ciqual_alim.element_children.each do |element|
          content = element.children.first.to_s.strip.encode("utf-8")
          case element.name
          when "alim_code"
            code = content
          when "alim_nom_fr"
            label = content
          end
        end
        @foods[code] = { source: SOURCE, source_code: code, source_label: label, nutrition_facts: {} } unless code.nil?
      end
      true
    end

    def parse_compo_file(filepath)
      @logger.debug "Parsing compo file…"
      doc = Nokogiri.XML(File.open(filepath, "r"))
      ciqual_compos = doc.xpath("//COMPO")
      total = ciqual_compos.length
      ciqual_compos.each_with_index do |ciqual_compo, i|
        @logger.debug "-> compo: #{i+1} / #{total}"
        alim_code = const_code = value = nil
        ciqual_compo.element_children.each do |element|
          content = element.children.first.to_s.strip.encode("utf-8")
          case element.name
          when "alim_code"
            alim_code = content
          when "const_code"
            const_code = content
          when "teneur"
            value = content
          end
        end
        nf_sym = NUTRITION_FACTS_MAPPINGS[const_code]
        if @foods.key?(alim_code) && nf_sym
          @foods[alim_code][:nutrition_facts][nf_sym] = value.sub(",", ".").to_f
        end
      end
      true
    end
  end

  class InvalidTypeError < StandardError; end
end
