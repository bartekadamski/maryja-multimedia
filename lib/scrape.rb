require "open-uri"

module Scrape
  extend self

  def start
    link = 'https://www.radiomaryja.pl/multimedia/audio/'
    doc = Nokogiri::HTML(open(link))
    doc.css('.container.template-blog main article').map{|p| p.attr('class')}
    articles = doc.css('.container.template-blog main article')
    articles.map do |article|
      class_with_id = article.attr('class').split().find{|klass| /\Apost-\d+\z/.match?(klass)}
      header_link = article.at_css('.entry-content-wrapper .entry-content-header .entry-title a')

      {
        post_id: class_with_id.delete('^0-9'),
        post_link: header_link['href'],
        title: header_link.text.strip()
      }
    end
  end
end