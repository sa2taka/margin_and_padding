FLAG_START_TAG = '<div class="flag">'
ROW_START_TAG = '<div class="row">'
CHAR_START_TAG = '<div class="char">'
DIV_END_TAG = '</div>'
NL = "\n"
FUND_STYLE = <<STYLE
p {
  margin: 0;
}

.flag {
  display: flex;
  flex-wrap: wrap;
}

.char {
  display: flex;
  flex-flow: column;
  margin-top: 2em;
  margin-left: 2em;
}

.row {
  display: flex;
}
STYLE

def random_string(n)
  'cl' + [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten.shuffle[0..n].join
end

def gen_tag(char)
  tag = CHAR_START_TAG + NL
  margins = []
  paddings = []
  char.each do |row|
    tag += ROW_START_TAG + NL
    row.chars.each do |c|
      klass = random_string(16)
      if c == '#'
        margins << klass
      else
        paddings << klass
      end
      tag += "<p class=\"#{klass}\"></p>"
    end 
    tag += DIV_END_TAG + NL
  end
  tag += DIV_END_TAG + NL
  [tag, margins, paddings]
end

def parse_chars(flag)
  flag.split.each_slice(5).to_a
end

flag = File.read('./flag.txt')

tag = ''
margins = []
paddings = []
parse_chars(flag).each do |c|
  t, m, p = gen_tag(c)
  tag += t
  margins.concat(m)
  paddings.concat(p)
end

m_style = margins.map{ |m| ".#{m} { margin: 24px; }" }.join(NL) + NL
p_style = paddings.map{ |m| ".#{m} { padding: 24px; }" }.join(NL) + NL

File.write('flag.html', FLAG_START_TAG + NL + tag + NL + DIV_END_TAG  + NL + "<style>" + NL + FUND_STYLE + NL + m_style + p_style + "</style>")
