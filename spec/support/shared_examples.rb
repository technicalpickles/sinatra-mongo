shared_examples_for 'all sinatra-mongo test apps' do
  describe 'GET /' do
    before(:each) do
      3.times { |i| mongo['test_collection'].insert({'x' => i }) }
    end

    after(:each) do
      mongo['test_collection'].remove
    end

    it 'fetches and shows the first element in test_collection' do
      get '/' do |response|
        response.body.should match('"x"=>0')
      end
    end
  end
end
