Dir.glob('*.vtt').each do |path|
  utterances = File.read(path).split("\r\n\r\n")
  raise if utterances[0] != "\ufeffWEBVTT"
  utterances.shift
  utterances.each do |utterance|
    print utterance.split("\n")[2..-1].map { |line| line.strip + ' ' }.join
  end
end
