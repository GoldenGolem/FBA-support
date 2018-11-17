if Rails.env == 'production'
	# Aws.config.update({
	#   region: 'us-east-1',
	#   credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY']),
	# })

	# S3_BUCKET = Aws::S3::Resource.new.bucket(ENV['S3_BUCKET'])

	Aws.config.update({
	  region: 'us-east-1',
	  credentials: Aws::Credentials.new('AKIAIEKKUDHSJUKMWBJA', 'vjX456/3QELfUrNsorq9ATJ2y/h8hM4KbDGmJRh1'),
	})
	
	S3_BUCKET = Aws::S3::Resource.new.bucket('fba-skynets-csvs')
else
	Aws.config.update({
	  region: 'us-east-1',
	  credentials: Aws::Credentials.new('AKIAIEKKUDHSJUKMWBJA', 'vjX456/3QELfUrNsorq9ATJ2y/h8hM4KbDGmJRh1'),
	})
	
	S3_BUCKET = Aws::S3::Resource.new.bucket('fba-skynets-csvs')
end