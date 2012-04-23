require 'benchmark'
require 'spec_helper'

RSpec::Matchers.define :take_less_than do |n|
  chain :seconds do; end

  match do |block|
    @elapsed = Benchmark.realtime do
      block.call
    end
    @elapsed <= n
  end

end

describe Cabalist::ModelAdditions do
  it "runs fast" do
    expect do
      10000.times { 1 + 2 }
    end.to take_less_than(0.01).seconds
  end
end