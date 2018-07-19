# frozen_string_literal: true

require 'zoho_hub/records/base_record'

module ZohoHub
  # The Potential class represents a Finpoint finance application (FinanceApplication model).
  class Potential < BaseRecord
    list_name 'Potentials'

    attributes :id, :code, :deal_name, :amount, :description, :stage
    attributes :company_age_years, :company_age_months, :term, :use_proceeds, :proceeds_detail
    attributes :currency, :territory, :employee_count, :turnover, :industry, :region
    attributes :review_outcome, :first_created, :last_modified, :preferred_term
    attributes :campaign_id, :account_id, :contact_id, :campaign_detail

    DEFAULTS = {
      currency: 'GBP',
      territory: 'UK all',
      campaign_detail: 'Web Sign Up'
    }.freeze

    # The translation from attribute name to the JSON field on Zoho. The default behaviour will be
    # to Camel_Case the attribute so on this list we should only have exceptions to this rule.
    attribute_translation(
      id: :id,
      code: :Project_Ref_No,
      description: :Project_description,
      employee_count: :Number_of_Employees,
      use_proceeds: :use_proceeds
    )

    def initialize(params)
      attributes.each do |attr|
        zoho_key = attr_to_zoho_key(attr)

        send("#{attr}=", params[zoho_key] || params[attr] || DEFAULTS[attr])
      end

      # Setup values as they come from the Zoho API if needed
      @account_id ||= params.dig(:Account_Name, :id)
      @contact_id ||= params.dig(:Contact_Name, :id)
      @campaign_id ||= params.dig(:Campaign_Source, :id)
    end

    def to_params
      params = super

      params[:Campaign_Source] = { id: @campaign_id } if @campaign_id
      params[:Account_Name] = { id: @account_id } if @account_id
      params[:Contact_Name] = { id: @contact_id } if @contact_id

      params
    end
  end
end
