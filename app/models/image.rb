class Image < ActiveRecord::Base
  belongs_to :visitation_form

  # Create temporary image files for all the form's images, and return the paths in an array
  def self.get_images(form_id)
    form = VisitationForm.find(form_id)

    arr = Array.new

    if form.images.count == 0
      return arr
    end

    img_index = 0
    form.images.each do |img|
      File.open('public/images/temp' + img_index.to_s, 'wb') { |file| file.write(img.data) }
      arr.push ( {:original_filename => img.filename, :temp_path => 'temp' + img_index.to_s} )
      img_index += 1
    end

    return arr
  end
end
