require 'anemone'
require 'nokogiri'

# Borrows a great deal of code from https://github.com/endymion/link-checker/blob/master/lib/link_checker.rb

class LinkCheckingMonkey

  CHECKED_URIS = []

  def initialize(target)
    @target = target
    @html_files = []
    @links = []
    @checked_pages = []
    @total_errors = []
    crawl_just_refinery_pages
  end

  def crawl
    threads = []
    Anemone.crawl(@target) do |anemone|
      anemone.storage = Anemone::Storage.PStore('tmp/link-monkey-crawled-pages.pstore')
      anemone.on_every_page do |crawled_page|
        raise StandardError.new(crawled_page.error) if crawled_page.error
        threads << check_page(crawled_page.body, crawled_page.url.to_s)
        @html_files << crawled_page
      end
    end
    threads.each{|thread| thread.join }
  end

  def crawl_just_refinery_pages
    threads = []
    Refinery::Page.where(draft: false).each do |page|
      threads << check_page(page.parts.map {|p| p.body}.join(' '), page.nested_path)
      @html_files << page
    end
    threads.each{|thread| thread.join }
    puts
    puts "All done. Checked #{@checked_pages.length} pages. Found #{@total_errors.length} errors."
    puts
    puts "Errors (only first occurence of URL mentioned):"
    puts
    @total_errors.each do |e|
      puts e
    end
  end

  def check_page(page, page_name)
    Thread.new do
      threads = []
      results = []
      self.class.external_link_uri_strings(page).each do |uri_string|

        if uri_string.in? @checked_pages
          # puts "  --- not checking again #{uri_string} on page #{page_name} #{@checked_pages.length}"
          next
        end
        # puts "  ==> check_uri #{uri_string} #{@checked_pages.length}"
        print '.'
        Thread.exclusive { @checked_pages << uri_string }

        Thread.exclusive { @links << page }
        # wait_to_spawn_thread
        threads << Thread.new do
          begin
            uri = URI(uri_string)
            response = self.class.check_uri(uri)
            if response
              response.uri_string = uri_string
              response.from = page_name
              Thread.exclusive { results << response }
            end
          rescue => error
            Thread.exclusive {
              results << Error.new( :error => error.to_s, :uri_string => uri_string, :from => page_name )
            }
          end
        end
      end
      threads.each {|thread| thread.join }
      report_results(page_name, results)
    end
  end


  def report_results(page_name, results)
    errors = results.select{|result| result.class.eql? Error}
    @total_errors += errors
#    warnings = results.select{|result| result.class.eql? Redirect}
#    goods = results.select{|result| result.class.eql? Good}
#    puts "
##{page_name} errors: #{errors}, warnings: #{warnings},
#checked_links: #{@checked_pages.length} total_errors: #{@total_errors}
#good: #{goods}
#"
  end


  # Find a list of all external links in the specified target, represented as URI strings.
  #
  # @param source [String] Either a file path or a URL.
  # @return [Array] A list of URI strings.
  def self.external_link_uri_strings(source)
    Nokogiri::HTML(source).css('a').select {|link|
      !link.attribute('href').nil? &&
          link.attribute('href').value =~ /^https?\:\/\//
    }.map{|link| link.attributes['href'].value.strip }
  end


  # Check one URL.
  #
  # @param uri [URI] A URI object for the target URL.
  # @return [LinkChecker::Result] One of the following objects: {LinkChecker::Good},
  # {LinkChecker::Redirect}, or {LinkChecker::Error}.
  def self.check_uri(uri, redirected=false)

    if LinkCheckingMonkey::CHECKED_URIS.include? uri
      return
    end
    Thread.exclusive { LinkCheckingMonkey::CHECKED_URIS << uri }

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true if uri.scheme == "https"
    http.start do
      path = (uri.path.empty?) ? '/' : uri.path
      http.request_get(path) do |response|
        case response
          when Net::HTTPSuccess then
            if redirected
              return Redirect.new(:final_destination_uri_string => uri.to_s)
            else
              return Good.new(:uri_string => uri.to_s)
            end
          when Net::HTTPRedirection then
            uri =
                if response['location'].match(/\:\/\//) # Allows for https://
                  URI(response['location'])
                else
                  # If the redirect is relative we need to build a new uri
                  # using the current uri as a base.
                  URI.join("#{uri.scheme}://#{uri.host}:#{uri.port}", response['location'])
                end
            return self.check_uri(uri, true)
          else
            return Error.new(:uri_string => uri.to_s, :error => response)
        end
      end
    end
  end



  # Abstract base class for representing the results of checking one URI.
  class Result
    attr_accessor :uri_string
    attr_accessor :from

    # A new LinkChecker::Result object instance.
    #
    # @param params [Hash] A hash of parameters. Expects :uri_string.
    def initialize(params)
      @uri_string = params[:uri_string]
      @from = params[:from]
    end
  end

  # A good result. The URL is valid.
  class Good < Result
  end

  # A redirection to another URL.
  class Redirect < Result
    attr_reader :good
    attr_reader :final_destination_uri_string

    # A new LinkChecker::Redirect object.
    #
    # @param params [Hash] A hash of parameters. Expects :final_destination_uri_string,
    # which is the URL that the original :uri_string redirected to.
    def initialize(params)
      @final_destination_uri_string = params[:final_destination_uri_string]
      @good = params[:good]
      super(params)
    end
  end

  # A bad result. The URL is not valid for some reason. Any reason, other than a 200
  # HTTP response.
  #
  # @param params [Hash] A hash of parameters. Expects :error, which is a string
  # representing the error.
  class Error < Result
    attr_reader :error
    def initialize(params)
      @error = params[:error]
      super(params)
    end
    def to_s
      "#{@uri_string}: #{@error} on page #{@from}"
    end
  end

end