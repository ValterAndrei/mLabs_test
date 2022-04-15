class PlateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value =~ /[A-Z]{3}-[0-9][0-9A-Z][0-9]{2}/

    record.errors.add attribute, (options[:message] || 'with invalid format')
  end
end

# # Another example:
# class PlateValidator < ActiveModel::Validator
#   def validate(record)
#     return if record.plate =~ /[A-Z]{3}-[0-9][0-9A-Z][0-9]{2}/

#     record.errors.add :plate, 'with invalid format'
#   end
# end

# # Add in our model:
# include ActiveModel::Validations
# validates_with PlateValidator
