module Ciqual
  class XmlParser
    attr_reader :food_groups, :foods

    def initialize(dirpath)
      @dirpath = Pathname.new(dirpath)
      @logger = Rails.logger
    end

    def parse!
      files = {
        const_file: nil,
        alim_grp_file: nil,
        alim_file: nil,
        compo_file: nil
      }

      Dir.glob(@dirpath.join("*.xml")).each do |filepath|
        filename = filepath.remove("#{@dirpath}/")
        if filename.match?(/^alim_grp_/)
          files[:alim_grp_file] = filepath
        elsif filename.match?(/^alim_/)
          files[:alim_file] = filepath
        elsif filename.match?(/^const_/)
          files[:const_file] = filepath
        elsif filename.match?(/^compo_/)
          files[:compo_file] = filepath
        end
      end

      parse_const_file(files[:const_file])
      parse_alim_grp_file(files[:alim_grp_file])
      parse_alim_file(files[:alim_file])
      parse_compo_file(files[:compo_file])

      true
    end

    protected

    def parse_alim_grp_file(filepath)
      @logger.debug "Parsing alim grp file…"
      @food_groups = {}
      doc = Nokogiri.XML(File.open(filepath, "r"))
      ciqual_groups = doc.xpath("//ALIM_GRP")
      total = ciqual_groups.length
      ciqual_groups.each_with_index do |ciqual_group, i|
        @logger.debug "-> alim grp: #{i+1} / #{total}"
        code = label = nil
        ciqual_group.element_children.each do |element|
          content = element.children.first.to_s.strip.encode("utf-8")
          if element.name == "alim_ssssgrp_code" && content != "000000"
            code = content
          end
          if element.name == "alim_ssssgrp_nom_fr"
            label = content
          end
        end
        @food_groups[code] = { code: code, label: label } unless code.nil?
      end
      true
    end

    def parse_alim_file(filepath)
      @logger.debug "Parsing alim file…"
      @foods = {}
      doc = Nokogiri.XML(File.open(filepath, "r"))
      ciqual_alims = doc.xpath("//ALIM")
      total = ciqual_alims.length
      ciqual_alims.each_with_index do |ciqual_alim, i|
        @logger.debug "-> alim: #{i+1} / #{total}"
        code = label = group_code = nil
        ciqual_alim.element_children.each do |element|
          content = element.children.first.to_s.strip.encode("utf-8")
          case element.name
          when "alim_code"
            code = content
          when "alim_nom_fr"
            label = content
          when "alim_ssssgrp_code"
            group_code = @food_groups.key?(content) ? content : nil
          end
        end
        @foods[code] = { code: code, label: label, food_group_code: group_code, nutrition_facts: [] } unless code.nil?
      end
      true
    end

    def parse_const_file(filepath)
      @logger.debug "Parsing const file…"
      @components = {}
      doc = Nokogiri.XML(File.open(filepath, "r"))
      ciqual_consts = doc.xpath("//CONST")
      total = ciqual_consts.length
      ciqual_consts.each_with_index do |ciqual_const, i|
        @logger.debug "-> const: #{i+1} / #{total}"
        code = label = nil
        ciqual_const.element_children.each do |element|
          content = element.children.first.to_s.strip.encode("utf-8")
          case element.name
          when "const_code"
            code = content
          when "const_nom_fr"
            label = content
          end
        end
        @components[code] = { code: code, label: label } unless code.nil?
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
        @foods[alim_code][:nutrition_facts] << @components[const_code].merge({ value: value }) unless alim_code.nil?
      end
      true
    end
  end

  class InvalidTypeError < StandardError; end
end
