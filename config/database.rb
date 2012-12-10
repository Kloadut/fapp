MongoMapper.connection = Mongo::Connection.new('localhost', nil, :logger => logger)

case Padrino.env
  when :development then MongoMapper.database = 'fapp_development'
  when :production  then MongoMapper.database = 'fapp_production'
  when :test        then MongoMapper.database = 'fapp_test'
end
