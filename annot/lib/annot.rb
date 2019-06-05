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
      c.option '--dest DIR', String, 'Destination directory'
      c.action do |args, options|

        begin
          extract = File.open(options.dest, "w")  

          doc = Nokogiri::XML(File.open(args[0]))
          doc.remove_namespaces!
          annotations = doc.xpath('/annotationSet/annotation')
          
          current_page = ""
          annotations.each do |a|
            page = a.at('title').text.split(',')[0]
            if current_page != page 
              extract.write("# #{page}\n")
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
