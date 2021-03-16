class Task < ApplicationRecord
    validates :title, :short, :time, :regularity, presence: true

    validates_uniqueness_of :short

    has_many :task_methods
end
