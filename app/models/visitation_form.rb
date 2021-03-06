class VisitationForm < ActiveRecord::Base
  has_many :images
  has_many :birds
  has_many :owners
  has_many :audit_log_entries

  validates :nest_id, numericality: { only_integer: true, message: I18n.t('error_value_must_be_number'), allow_nil: true }
  validates :nest_id, length: { maximum: 5, message: I18n.t('error_value_too_long') }
  validates :nest, presence: { precence: true, message: I18n.t('error_must_be_present') }

  if Rails.env.test?
    @tipuapi = TipuApiHelperMock
  else
    @tipuapi = TipuApiHelper
  end

  validates :municipality, inclusion: { in: @tipuapi.GetMunicipalities.map {|v| v['id'] }, message: I18n.t('error_invalid_municipality')}
  validates :species_id, inclusion: { in: @tipuapi.GetSpecies['species'].map {|v| v['id'] }, message: I18n.t('error_invalid_species')}

  validates :photographer_id, presence: { message: I18n.t('error_must_be_present') }
  validate do |form|
    if Rails.env.test?
      @tipuapi = TipuApiHelperMock
    else
      @tipuapi = TipuApiHelper
    end

    ringers = @tipuapi.GetRingerById(form.photographer_id)


    if !ringers['ringers']['ringer']
      form.errors[:photographer_id] << I18n.t('error_invalid_photographer_id')
    end


    if form.owners.count == 0
      form.errors[:owners] << I18n.t('error_must_have_one_owner')
    end

    if !form.visit_date.nil? && form.visit_date > Date.today
      form.errors[:visit_date] << I18n.t('error_date_in_future')
    end

    # If the class was anything else than a string, say datetime or date it should already be valid and not parsed again
    if !form.visit_date_before_type_cast.nil? && form.visit_date_before_type_cast.kind_of?(String)
      begin
        date = Date.parse(form.visit_date_before_type_cast)
      rescue
        form.errors[:visit_date] << I18n.t('error_date_invalid')
      end
    end
  end

  def self.get_forms_of_type(user, type, sortby, order, nestid, speciesid, datefrom, dateto, nestname, photographername)

    # If no sorting is given, results are sorted by creation timestamp and newest first (desc)
    if (not defined? sortby or sortby.nil? or not VisitationForm.column_names.include? sortby )
      allForms = VisitationForm.order("created_at desc")
    else
      if not defined? order or order.nil?
        order = "asc"
      end
      allForms = VisitationForm.order(sortby + " " + order)
    end

    allForms = allForms.where(:nest_id => nestid.split(',')) unless nestid.nil? || nestid == ''
    allForms = allForms.where("upper(nest) LIKE upper(?)", nestname + "%") unless nestname.nil? || nestname == ''
    allForms = allForms.where(species_id: speciesid) unless speciesid.nil? || speciesid == ''
    allForms = allForms.where('visit_date >= ?', datefrom) unless datefrom.nil? || datefrom == ''
    allForms = allForms.where('visit_date <= ?', dateto) unless dateto.nil? || dateto == ''
    allForms = allForms.where("upper(photographer_name) LIKE upper(?)", photographername + "%") unless photographername.nil? || photographername == ''

    if user[:type] != 'admin'
      allForms = allForms.includes([:owners]).where(['owners.owner_id = ? OR photographer_id = ?', user[:login_id], user[:login_id]])
    end

    if(type == "submitted")
      @visitation_forms = allForms.select { |f| f.sent == true && f.approved != true }
    elsif (type == "unsubmitted")
      @visitation_forms = allForms.select { |f| f.sent != true && f.approved != true }
    elsif(type == "archive")
      if user[:type] == 'admin'
        @visitation_forms = allForms.select { |f| f.approved == true }
      else
        return false
      end
    end
  end




  def self.user_has_access_to_form user, form
    return true if user[:type] == 'admin'
    return true if form.owners.any? |o| o.owner_id == user[:login_id]
    return true if form.photographer_id == user[:login_id]
    return false
  end
end
