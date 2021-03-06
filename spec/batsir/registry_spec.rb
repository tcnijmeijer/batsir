require File.join( File.dirname(__FILE__), "..", "spec_helper" )

describe Batsir::Registry do

  before :all do
    @class = Batsir::Registry
  end

  before :each do
    @class.reset
  end

  it "outputs the whole registry" do
    @class.registry.should == {}
  end

  it "registers a value" do
    @class.register(:foo, :bar)
    @class.registry.keys.size.should == 1
    @class.registry.keys.should include :foo
    @class.registry.values.size.should == 1
    @class.registry.values.should include :bar
  end

  it "is able to retrieve a registered variable" do
    @class.register('test', 'value')
    @class.get('test').should == 'value'
  end

  it "returns nil when the requested key is not found" do
    @class.get('foobar').should be_nil
  end

  context "resetting" do
    it "is possible" do
      @class.register('foo', 'bar')
      @class.registry.should == {'foo' => 'bar'}
      @class.reset
      @class.registry.should == {}
    end

    it "returns its new state" do
      @class.register('foo', 'bar')
      result = @class.reset
      result.should == {}
    end
  end
end
