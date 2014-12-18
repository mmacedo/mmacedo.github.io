require './plugins/pygments_code'
require 'open3'

def genExtra(lang,fig_id)
  if @lang == "coffeescript"
    return "<span class=\"switchLang\"><a class=\"switchLang selected\" onclick=\"switchLang(event,this,'#{fig_id}');\">.coffee</a><a class=\"switchLang\" onclick=\"switchLang(event,this,'#{fig_id}');\">.js</a></span>"
  end
end

module BacktickCodeBlock
  AllOptions = /([^\s]+)\s+(.+?)\s+(https?:\/\/\S+|\/\S+)\s*(.+)?/i
  LangCaption = /([^\s]+)\s*(.+)?/i
  def self.render_code_block(input)
    @options = nil
    @caption = nil
    @lang = nil
    @url = nil
    @title = nil
    input.gsub(/^`{3} *([^\n]+)?\n(.+?)\n`{3}/m) do
      @options = $1 || ''
      str = $2

      extra = ''
      id = rand(999999999)
      fig_id = "figure_#{id}"

      if @options =~ AllOptions
        @lang = $1
        extra = genExtra @lang, fig_id
        @caption = "<figcaption>#{extra}<span>#{$2}</span><a href='#{$3}'>#{$4 || 'link'}</a></figcaption>"
      elsif @options =~ LangCaption
        @lang = $1
        extra = genExtra @lang, fig_id
        @caption = "<figcaption>#{extra}<span>#{$2}</span></figcaption>"
      end

      if str.match(/\A( {4}|\t)/)
        str = str.gsub(/^( {4}|\t)/, '')
      end
      if @lang.nil? || @lang == 'plain'
        code = HighlightCode::tableize_code(str.gsub('<','&lt;').gsub('>','&gt;'))
        "<figure class='code'>#{@caption}#{code}</figure>"
      else
        if @lang.include? "-raw"
          raw = "``` #{@options.sub('-raw', '')}\n"
          raw += str
          raw += "\n```\n"
        else
          code = HighlightCode::highlight(str, @lang)
          if extra == ''
            "<figure class='code'>#{@caption}#{code}</figure>"
          else
            alt_lang = ''
            str2 = ''
            altcode = ''
            if @lang == 'coffeescript'
              lang_display = 'CoffeeScript'
              alt_lang = 'javascript'
              alt_lang_display = 'JavaScript'
              stdin, stdout, stderr, wait_thr = Open3.popen3("coffee -s -b -c -p")
              stdin.print(str)
              stdin.close
              str2 = stdout.readlines(nil)[0]
              if !str2
                str2 = stderr.readlines(nil)[0]
                str2 = "Compilation failed: \n#{str2}"
              end
              stdout.close
              stderr.close
              exit_status = wait_thr.value
            end
            if alt_lang != ''
              altcode = HighlightCode::highlight(str2, alt_lang)
            end
            "<figure class='code'>#{@caption}<div clang='#{lang_display}' id=\"#{fig_id}\">#{code}</div><div clang='#{alt_lang_display}' id=\"#{fig_id}_alt\" style=\"display:none;\">#{altcode}</div></figure>"
          end
        end
      end
    end
  end
end
