#!/usr/bin/env ruby

require 'rubygems'
require 'commander'

require 'annot/version'

require 'nokogiri'

class App
  include Commander::Methods
  # include whatever modules you need

  def run
    program :name, 'annot'
    program :version, Annot::VERSION
    program :description, 'Extract annotations'

    command :extract do |c|
      c.syntax = 'annot extract <file> [options]'
      c.summary = ''
      c.description = ''
      c.example 'description', 'command example'
      c.option '--dest FILE', String, 'Destination directory'
      c.option '--offset NUM', Integer, 'Page offset'
      c.action do |args, options|
        options.default :offset => 0

        begin
          extract = File.open(options.dest, "w")  

          doc = Nokogiri::XML(File.open(args[0]))
          doc.remove_namespaces!
          annotations = doc.xpath('/annotationSet/annotation')
          
          current_page = ""
          page_num = 0
          
          annotations.each do |a|
            page = a.at('title').text.split(',')[0]
            if current_page != page
              page_num = page.split(' ')[1].to_i + options.offset
              extract.write("# Page #{page_num}\n")
              current_page = page
            end
            extract.write("#{a.at('target').at('fragment').at('text').text}\n\n")
          end

        rescue => e
          puts "OOPS ! #{e}"
        ensure
          extract.close unless extract.nil?
        end

      end
    end

    run!
  end
end

App.new.run if $0 == __FILE__
