Dir["tasks/*.rake"].each { |ext| load ext }

def log(msg = '')
  puts msg
end

def deploy
  `scp -r book/output/* ninja@4ninjas.org:public_html/merb/`
end
