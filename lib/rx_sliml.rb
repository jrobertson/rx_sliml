#!/usr/bin/env ruby

# file: rx_sliml.rb

require 'kvx'
require 'rexle-builder'
require 'nokogiri'


class RxSlimlException < Exception 
end

class RxSliml

  attr_reader :to_xslt, :to_html

  def initialize(sliml=nil, obj=nil, fields: nil)

    # assumes the obj is either a Kvx object or responds to :to_kvx
    #
    @rx = if obj then
    
      if obj.is_a? Kvx then
        obj
      elsif obj.respond_to? :to_kvx
        obj.to_kvx
      elsif obj.respond_to? :to_xml
        obj
      else
        raise RxSlimlException, 'reference object not recognised'
      end
    end
    
    if sliml.nil? and fields.nil? then
      raise RxSlimlException, 'RxSliml: please enter a sliml string or ' + 
          'an array of fields' 
    end
    
    sliml ||= create_sliml(fields)
    @sliml = sliml    

    sliml.gsub!(/\{[^\}]+/) do |x|
      x.gsub(/["']?(\S*)\$(\w+)([^"']*)["']?/,'\'\1{\2}\3\'')
    end    
    
    xml = LineTree.new(sliml).to_xml declaration: false, pretty: true
    
    @recxsl = xml.gsub(/\$(\w+)/, '<xsl:value-of select="\1"/>')
    
    @to_xslt = build_xslt

    xslt  = Nokogiri::XSLT(@to_xslt)
    @to_html = xslt.transform(Nokogiri::XML(@rx.to_xml)) if @rx
    
  end
  
  def to_sliml()
    
    @sliml
    
  end


  private

  def build_xslt()

    xml = RexleBuilder.new
    raw_a = xml.xsl_stylesheet(xmlns_xsl: \
                     "http://www.w3.org/1999/XSL/Transform", version: "1.0") do
      xml.xsl_output(method: "xml", indent: "yes", \
                                              :"omit-xml-declaration" => "yes")

      xml.xsl_template(match: 'kvx') do
        xml.html do
          xml.head do
            xml.title do
              xml.xsl_value_of select: 'summary/title'
            end
          end 
          xml.body do
            xml.header do
              xml.xsl_apply_templates(select: 'summary')
            end
            xml.main do
              xml.xsl_apply_templates(select: 'body')
            end
          end 
        end
      end

      xml.xsl_template(match: 'kvx/summary') do
        
        xml.dl do
          xml.xsl_for_each(select: '*') do
            xml.dt do
              xml.xsl_value_of(select: 'name()')
            end
            xml.dd do
              xml.xsl_value_of(select: '.')
            end
          end
        end
      end

      xml.xsl_template(match: 'body') do

        xml.rec_template

      end

    end

    xml2 = Rexle.new(raw_a).xml(pretty: true).gsub('xsl_apply_templates',\
        'xsl:apply-templates').gsub('xsl_value_of','xsl:value-of').\
        gsub('xsl_template','xsl:template').\
        gsub('xmlns_xsl','xmlns:xsl').gsub('xsl_for_each','xsl:for-each').\
        gsub('xsl_','xsl:')

    xml2.sub('<rec_template/>', @recxsl)
  end

  def create_sliml(fields)
    
    lines = ['dl']
    lines << fields.map {|field| "  dt %s:\n  dd $%s\n" % ([field.to_s]*2) }
    lines.join("\n")
    
  end

end
