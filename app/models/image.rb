require 'digest/md5'

class Image < ActiveRecord::Base
  belongs_to :visitation_form

  before_validation :calculate_md5

  validates :checksum, uniqueness: true

  def calculate_md5
    self.checksum = Digest::MD5.hexdigest(self.data)
  end

  # Create temporary image files for all the form's images, and return the paths in an array
  def self.get_all_images(form_id)
    form = VisitationForm.find(form_id)

    arr = Array.new

    img_index = 0
    form.images.each do |img|
      File.open('public/images/temp' + img_index.to_s, 'wb') { |file| file.write(img.thumbnaildata.nil? ? img.data : img.thumbnaildata) }
      arr.push ( {:id => img.id, :original_filename => img.filename, :temp_path => 'temp' + img_index.to_s} )
      img_index += 1
    end

    return arr
  end

  def self.get_bird1_images(form_id)
    return get_images_of_type form_id, 1
  end

  def self.get_bird2_images(form_id)
    return get_images_of_type form_id, 2
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

    img_index = 0

    images.each do |img|
      if img.image_type == type
        temp_folder = 'public/images/'
        temp_filename = 'temp' + type.to_s + img_index.to_s
        File.open(temp_folder + temp_filename, 'wb') { |file| file.write(img.thumbnaildata.nil? ? img.data : img.thumbnaildata) }
        arr.push ( {:id => img.id, :gender => img.gender, :original_filename => img.filename, :temp_path => temp_filename} )
        img_index += 1
      end
    end

    return arr
  end
end
