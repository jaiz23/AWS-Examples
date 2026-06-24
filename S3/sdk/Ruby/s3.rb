# Load the AWS SDK for S3 operations
require 'aws-sdk-s3'

# Debugging tool (allows interactive debugging with binding.pry)
require 'pry'

# Used to generate random UUID strings
require 'securerandom'

# Read the bucket name from an environment variable
bucket_name = ENV['BUCKET_NAME']

# AWS region where the bucket should be created
region = 'eu-north-1'

# Print the bucket name to verify it was loaded correctly
puts bucket_name

# Create an S3 client using configured AWS credentials
client = Aws::S3::Client.new

# Create a new S3 bucket
resp = client.create_bucket({
  bucket: bucket_name,

  # Region configuration for the bucket
  create_bucket_configuration: {
    location_constraint: region
  }
})

# binding.pry
# Generate a random number between 1 and 6
# This determines how many files will be created and uploaded
number_of_files = 1 + rand(6)

puts "number_of_files: #{number_of_files}"

# Loop through the number of files
number_of_files.times.each do |i|

  puts "i: #{i}"

  # Create a filename such as file_0.txt, file_1.txt, etc.
  filename = "file_#{i}.txt"

  # Temporary location on the local machine
  output_path = "/tmp/#{filename}"

  # Create a file and write a random UUID into it
  File.open(output_path, "w") do |f|
    f.write SecureRandom.uuid
  end

  # Open the file in binary read mode
  File.open(output_path, 'rb') do |f|

    # Upload the file to the S3 bucket
    # key = object name in S3
    # body = file contents
    client.put_object(
      bucket: bucket_name,   # Use variable, not string literal
      key: filename,
      body: f
    )
  end
end

puts "Upload complete!"