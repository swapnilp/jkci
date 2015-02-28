class ResultsPhoto < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  require 'open-uri'
  require 'net/http'

  #attr_accessible :image, :image_file_name, :height, :width, :attachable_type, :attachable_id

  #has_attached_file :image, 
  #    :whiny => true,
  #    :path => ":rails_root/public/system/result_image/:id/:style/:filename",
  #    :url => "/system/result_image/:id/:style/:filename",
  #    :styles => { :medium => "400x400>", :hunt_img => "x400",
  #    :thumb => "212x" }
 
  has_attached_file :image,
    :whiny => true,
    :storage => :s3,
    :path => "#{SERVER_TYPE}/result_image/:id/:style/:filename",
    :url => "http://s3-ap-southeast-1.amazonaws.com/jkciPhoto/#{SERVER_TYPE}/result_image/:id/:style/:filename",
    :s3_credentials => File.join(Rails.root,'config', 's3.yml'),
    :s3_premissions => 'public',
    :s3_protocol => 'http',
    :bucket => 'jkciphoto',
    :styles => { :medium => "400x400>", :hunt_img => "x400",
      :thumb => "212x" }


  #after_create :transliterate_file_name

#  validates_attachment :image, 
#			:presence => true, 
#			:content_type => { :content_type => ["image/jpg", "image/jpeg", "image/gif", "image/png"] },
#			:size => { :less_than => 4.megabytes }

  validates_attachment_size :image, :less_than=>5.megabyte, message: "Oops! the file you have selected is too large. You can only upload a file less than 5 MB"
  validates_attachment_content_type :image, :content_type=>['image/jpeg', 'image/png', "image/jpg","image/pjpeg", "image/gif"], message: "Oops! only Jpeg, Jpg, PJpeg & Gif files are supported."
  validate :image_content, :on => :create
=begin
  if true #Rails.env.production?
    has_attached_file :image, 
     :whiny => true,
     :storage => :s3,
     :path => "#{SERVER_TYPE}/seek_image/:id/:style/:filename",
     :url => "http://s3.amazonaws.com/buploads/#{SERVER_TYPE}/seek_image/:id/:style/:filename",
     :s3_credentials => File.join(Rails.root,'config', 's3.yml'),
     :s3_premissions => 'public',
     :s3_protocol => 'http',
     :bucket => 'buploads',
     :styles => { :medium => "400x400>", :hunt_img => "x400", 
      :thumb => "212x" }
  else
    has_attached_file :image, 
      :whiny => true,
      :path => ":rails_root/public/system/image/:id/:style/:filename",
      :url => "/system/image/:id/:style/:filename",
      :styles => { :medium => "400x400>", :hunt_img => "x400",
      :thumb => "212x" }
    #has_attached_file :image, 
    # :whiny => true,
    # :storage => :s3,
    # :path => "#{SERVER_TYPE}/seek_image/:id/:style/:filename",
    # :url => "http://s3.amazonaws.com/buploads/#{SERVER_TYPE}/seek_image/:id/:style/:filename",
    # :s3_credentials => File.join(Rails.root,'config', 's3.yml'),
    # :s3_premissions => 'public',
    # :s3_protocol => 'http',
    # :bucket => 'buploads',
    # :styles => { :medium => "400x400>", :hunt_img => "x400", 
    # :thumb => "212x" }
  end
=end
  
  #process_in_background :image
  
    
  def image_from_url(url)
    uri = URI.parse(url)
    
    file_name = uri.path.split('/').last
    file_name = file_name.strip.gsub('\s','')
    
    content = open(uri)
    content_type = content.content_type if content.respond_to? :content_type
    content_type ||= 'text/html'
    
    extension = File.extname(file_name)  	
    GC.disable
    file = Tempfile.new(["stream" , extension]).binmode
    
    while data = content.read(16*1024)
      file.write(data)
    end
    file.rewind
    
    begin
      self.image = (Rack::Multipart::UploadedFile.new( file.path, content_type ))
    rescue
      self.errors.add :image, :invalid, :type =>Paperclip::Errors::NotIdentifiedByImageMagickError.new("Please retry")
    end
  ensure
    GC.enable
    
    return self
  end
  
  def transliterate_file_name
    extension = File.extname(image_file_name).gsub(/^\.+/, '')
    filename  = image_file_name.gsub(/\.#{extension}$/, '')
    self.image.instance_write(:file_name, "#{Time.now.to_i.to_s}.#{transliterate(extension)}")
  end

  def image_url(type= 'original')
    image.url(type.to_sym)
  end

  def flickers_images
    {image_url('thumb') =>  album_path(album_id)}
  end


  private

  def transliterate(str)
    #s = Iconv.iconv('ascii//ignore//translit', 'utf-8', str).to_s
		s = str.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => "?")
    s.downcase!
    s.gsub!(/'/,'')
    s.gsub!(/[^A-Za-z0-9]+/, ' ')
    s.strip!
    s.gsub!(/\ +/, '-')
    return s
  end

  def image_content
    begin
      Paperclip.run("identify", image.queued_for_write[:original].path ) unless image.queued_for_write[:original].nil?
    rescue Cocaine::ExitStatusError
      errors.add :image, :invalid, :type =>Paperclip::Errors::NotIdentifiedByImageMagickError.new("Invalid file")
    end
  end
end


