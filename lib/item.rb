require 'yaml'
require 'digest/md5'
require 'date'

class Nanoc3::Item

  def kind
    kinds = {
      'pages' => 'page',
      'articles' => 'article'
    }
    split = self.identifier.split('/')
    kinds[split[1]] || 'none'
  end

  def page?
    self.readable? && self.kind == 'page'
  end

  def article?
    self.readable? && self.kind == 'article'
  end

  def readable?
    readable = %w[html md haml txt]
    readable.include? self.attributes[:extension]
  end

  def author
    @author ||= Member.new(self[:author])
  end

  def year
    date = Date.parse(self.readable? ? self.attributes[:date].to_s : self.parent.attributes[:date].to_s)
    date.year
  end

  def route
    @route_ ||= get_route
  end

  def base_route
    @base_route_ ||= get_base_route
  end

private

  def get_base_route
    base = '/' + self.year.to_s + self.identifier.gsub(/\/articles/, '')
  end

  def get_route
    base = self.base_route
    self.readable? ? base + 'index.html' : base.chop + '.' + self.attributes[:extension]
  end

end
