# frozen_string_literal: true

require 'csv'

module Util
  N = 2.freeze

  class AddressBuilder
    def initialize
      clear
    end

    def clear
      @postal_code = ''
      @address = []
      @numbers = []
    end

    # row[2]: 郵便番号
    # row[6]: 都道府県名
    # row[7]: 市区町村名
    # row[8]: 町域名
    def add(row, number = -1)
      @postal_code = row[2]

      if @address.empty?
        @address = row[6, 3]
      else
        @address[2] += row[8]
      end

      @numbers << number
    end

    def to_h
      remove_noise
      { postal_code: @postal_code, address: @address, numbers: @numbers }
    end

    def remove_noise
      return if @address[2].nil?

      noises = %w(以下に掲載がない場合 の次に番地がくる場合)

      if noises.any? { |noise| @address[2].include?(noise) }
        @address.pop
      end
    end

    def complete?
      @address[2].count('（') == @address[2].count('）')
    end
  end

  def self.make_ngram(str)
    str.each_char.each_cons(N).map { |chars| chars.join }
  end
end
