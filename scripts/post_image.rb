#!/usr/bin/env ruby

# hatenablog.rb
# 別途下記環境変数が必要
# HATENABLOG_CONSUMER_KEY
# HATENABLOG_CONSUMER_SECRET
# HATENABLOG_ACCESS_TOKEN
# HATENABLOG_ACCESS_TOKEN_SECRET
# 例
# ruby hatenablog.rb --filename docs/hoge/fuga.md --draft --user hoge --site hoge-fuga.hatenablog.com
#
# 下記ファイル構成を前提としている
# markdown: entry/${issune#num}/draft.md
# image: entry/${issune#num}/image/xxx.jpg

require 'oauth'
require 'oga'
require 'json'
require 'active_support/core_ext/hash'
require 'xmlsimple'
require 'base64'
require 'mime/types'
require 'optparse'
require 'cgi'

class Executor
  attr_reader :header, :hatena, :args, :json, :photolife

  DATA_FILE = 'image.json'

  class << self
    def get_token(site)
      consumer = OAuth::Consumer.new(
        ENV['HATENABLOG_CONSUMER_KEY'],
        ENV['HATENABLOG_CONSUMER_SECRET'],
        site: 'http://f.hatena.ne.jp',
        timeout: 300
      )

      OAuth::AccessToken.new(
        consumer,
        ENV['HATENABLOG_ACCESS_TOKEN'],
        ENV['HATENABLOG_ACCESS_TOKEN_SECRET']
      )
    end
  end

  def initialize(args)
    @args = args
    @header = {
      'Accept' => 'application/xml',
      'Content-Type' => 'application/xml'
    }
    json_file = args[:imagedir] + "/" + DATA_FILE
    @photolife = Executor.get_token
    @json = JSON.parse(File.read(json_file))
  end

  def post_image(image_filename, filename, image_dir)
    return image_filename unless image_filename.match('http').nil?

    image_path = "#{image_dir}/#{image_filename}"
    
    puts "#{json.class}"
    puts "#{image_filename}"

    if (json.dig(image_filename).nil?)
      xml = upload_image(@photolife, image_path)
      hash = XmlSimple.xml_in(xml)
      syntax = "[#{hash['syntax'].first}]"

      json[image_filename] = {
        syntax: syntax,
        id: hash['id'].first,
        image_url: hash['imageurl'].first
      }

      syntax
    else
      json.dig(image_filename, 'syntax')
    end
  end

  def generate_body(filename, image_dir)
    markdown = File.read(filename)

    # はてフォトライフの画像へ差し替え
    markdown.gsub!(/!\[.*\]\((.*)\)/) { post_image($1, filename, image_dir) }

    markdown
  end

  def execute
    generated_body = generate_body(args[:filename], args[:imagedir])

    File.write(DATA_FILE, JSON.pretty_generate(json, indent: "   ", space_before: ' '))
  end

  def upload_image(client, filename, dirname = 'Hatena Blog')
    content = Base64.encode64(File.read(filename))
    mime_type = MIME::Types.type_for(filename).first
    title = File.basename(filename, '.*')

    body = <<-"ENTRY"
<entry xmlns="http://purl.org/atom/ns#">
  <title>#{title}</title>
  <content mode="base64" type="#{mime_type}">
    #{content}
  </content>
  <dc:subject>#{dirname}</dc:subject>
</entry>
ENTRY

    res = client.request(:post, '/atom/post', body, @header)

    res.body
  end
end

args = ARGV.getopts('f:i','filename:', 'imagedir:').symbolize_keys

executor = Executor.new(args)
executor.execute
