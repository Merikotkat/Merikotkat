require 'digest/md5'

class Image < ActiveRecord::Base
  belongs_to :visitation_form
  belongs_to :bird

  before_validation :calculate_md5
  before_save :create_thumbnail

  #todo this should check if a unique image is already assigned to a form, or assigned to the same upload uuid. temporary images waiting for "garbage collection" should not prevent uploading the same image again
  validates :checksum, uniqueness: { uniqueness: true, message: I18n.t('error_image_already_exists') }


  validate do |image|
    extension = File.extname(image.filename).downcase
    accepted_formats = [".png", ".jpg", ".jpeg"]
    if !accepted_formats.include? extension
      image.errors[:content_type] << I18n.t('error_file_type_unsupported', type: extension)
    end
  end

  def calculate_md5
    self.checksum = Digest::MD5.hexdigest(self.data)
  end

  def image_type_name
    return "Adult" if (image_type == 1)
    return "Juvenile" if (image_type == 3)
    return "Landscape" if (image_type == 4)
    return "Nest" if (image_type == 5)
    return ""
  end

  def create_thumbnail
    begin
      image = MiniMagick::Image.read(self.data)
      image.resize "x150"
      self.thumbnaildata = image.to_blob
    rescue
      #puts 'Couldnt create thumbnail from image, perhaps this is a test environment?'
    end
  end

  def self.get_adult_images(form_id)
    return get_images_of_type form_id, 1
  end

  def self.get_young_images(form_id)
    return get_images_of_type form_id, 3
  end

  def self.get_landscape_images(form_id)
    return get_images_of_type form_id, 4
  end

  def self.get_nest_images(form_id)
    return get_images_of_type form_id, 5
  end

  def self.get_images_of_type(form_id, type)
    images = Image.where "visitation_form_id = ?", form_id

    arr = Array.new

    images.each do |img|
      if img.image_type == type
        arr.push ( img )
      end
    end

    return arr
  end
end
