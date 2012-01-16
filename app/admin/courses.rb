ActiveAdmin.register Course do

  scope :active
  scope :past

  index do
    column :title
    column :teaser
    column :status
    column "Course Date", :date
    column :price, :sortable => :price do |course|
      number_to_currency course.price
    end
    column :max_seats
    column :min_seats
    default_actions # show/edit/destroy
  end

end
