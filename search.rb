# frozen_string_literal: true

require 'csv'
require 'set'
require './util.rb'

def search_row_numbers(queries)
  index = nil
  File.open('index.dmp', 'r') do |f|
    index = Marshal.load(f)
  end

  numbers = []
  queries.each do |query|
    Util::make_ngram(query).each do |ngram|
      next if index[ngram].nil?

      if numbers.empty?
        numbers = index[ngram]
      else
        numbers &= index[ngram]
      end
    end
  end

  numbers
end

def get_results(path, numbers)
  csv = CSV.read(path, encoding: 'Shift_JIS:UTF-8')
  results = []

  numbers.each do |address_numbers|
    address = Util::AddressBuilder.new

    address_numbers.each do |number|
      address.add(csv[number])
    end

    results << address.to_h
  end

  results
end

def main
  queries = gets.strip.split
  numbers = search_row_numbers(queries)

  if numbers.empty?
    puts '検索結果と一致するものはありません。'
    return
  end

  results = get_results('./KEN_ALL.CSV', numbers)

  set = Set.new
  results.each do |result|
    contents = [result[:postal_code], *result[:address]]
    set.add(contents.map { |content| "\"#{content}\"" }.join(','))
  end

  set.each { |result| puts result }
end

if __FILE__ == $0
  main
end
