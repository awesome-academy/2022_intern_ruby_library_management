class ApplicationRecord < ActiveRecord::Base
  include ApplicationHelper
  self.abstract_class = true

  scope :this_month, (lambda do
    where(
      created_at: DateTime.now.beginning_of_month..DateTime.now.end_of_month
    )
  end)
end
