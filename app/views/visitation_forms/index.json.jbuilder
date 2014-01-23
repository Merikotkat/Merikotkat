json.array!(@visitation_forms) do |visitation_form|
  json.extract! visitation_form, :id, :photographer_name, :visit_date
  json.url visitation_form_url(visitation_form, format: :json)
end
