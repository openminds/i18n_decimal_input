module I18nDecimalInput
  def convert_number_column_value_with_i18n value
    if value.is_a?(String) && value.present?
      value.gsub(I18n.t('number.format.delimiter'), '').
            gsub(I18n.t('number.format.separator'), '.')
    else
      convert_number_column_value_without_i18n(value)
    end
  end
  
  def self.included base
    base.alias_method_chain :convert_number_column_value, :i18n
  end
end

ActiveRecord::Base.send(:include, I18nDecimalInput) if defined?(ActiveRecord)
