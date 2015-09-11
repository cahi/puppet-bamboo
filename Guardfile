notification :off

guard 'rake', :task => 'test' do
  watch(%r{^manifests\/(.+)\.pp$})
  watch(%r{^spec\/(.+)\.rb$})
  ignore(%r{^spec/fixtures})
end
