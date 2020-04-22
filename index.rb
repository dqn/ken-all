# frozen_string_literal: true

require './util.rb'

class CSVPreprocessor
  def initialize(path)
    @path = path
  end

  def preprocess
    address_data = []
    address = Util::AddressBuilder.new

    csv_each_with_row_number(@path) do |row, number|
      address.add(row, number)

      if address.complete?
        address_data << address.to_h
        address.clear
      end
    end

    address_data
  end

  private

  def csv_each_with_row_number(path)
    row_number = 0

    CSV.foreach(path, encoding: 'Shift_JIS:UTF-8') do |row|
      yield row, row_number
      row_number += 1
    end
  end
end

def make_index(address_data)
  index = {}

  address_data.each do |datum|
    datum[:address].each do |place|
      Util::make_ngram(place).each do |word|
        index[word] ||= []
        index[word] << datum[:numbers]
      end
    end
  end

  index
end

def main
  puts '1/3: start normalizing...'
  address_data = CSVPreprocessor.new('./KEN_ALL.CSV').preprocess
  
  puts '2/3: start indexing...'
  index = make_index(address_data)

  puts '3/3: start saving index file...'
  File.open('index.dmp', 'w') do |f|
    Marshal.dump(index, f)
  end

  puts 'completed!'
end

if __FILE__ == $0
  main
end
