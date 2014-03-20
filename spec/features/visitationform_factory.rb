class Visitationform_factory
    def self.GetValidVisitationForm
      formi = VisitationForm.new
      formi.save(:validate => false)
      formi.photographer_name = "Pekka Murkka"
      formi.visit_date = "2014-01-01"
      formi.camera = "Super Internal Cam"
      formi.lens = "Lens Man 2000"
      formi.teleconverter =  "TC Teleconv"
      formi.municipality = "HELSIN"
      formi.nest = "Roni's nest for children"
      formi.nest_id = 268
      formi.photographer_id = 2890
      formi.form_saver_id = 2890
      formi.species_id = 'HALALB'

      image = Image.new
      image.filename = 'hurr.jpg'
      image.data = SecureRandom.uuid  # Create random image to prevent md5sum from failing all tests
      formi.images << image

      formi.save
      return formi
    end
end