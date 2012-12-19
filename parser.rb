require 'csv'

count = 0
text = "<table class='table table-striped'>\n"
CSV.foreach("/Users/rafi/Desktop/applications2012.csv") do |row|
  if count == 0
    text += "<thead>\n<tr>"
    rowcount = 0
    infos = []
    row.each do |item|
      if rowcount == 0
        rowcount += 1
        next
      end
      if rowcount < 4 or rowcount == row.length - 1
        infos << item
        text += "<td>Info</td>" if rowcount == 3
      else
        text+= "<td>#{item}</td>"
      end
      rowcount += 1
    end
    text += "</tr>\n</thead>\n<tbody>\n"
  else
    text+= "<tr>"
    rowcount = 0
    infos = []
    row.each do |item|
      if rowcount == 0
        rowcount += 1
        next
      end
      if rowcount < 4 or rowcount == row.length - 1 
        infos << item
        if rowcount == 3
          infos << row[-1]
          info = infos.join("<br/>")
          text += "<td>#{info}</td>" 
        end
      else
        text+= "<td>#{item}</td>"
      end
      rowcount+=1
    end
    text += "</tr>\n"
  end

  count+=1
end
text += "</tbody>\n</table>"

puts text