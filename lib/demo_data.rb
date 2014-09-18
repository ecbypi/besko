require 'faker'

class DemoData
  def seed!
    create_admin_user!
    create_users!
    create_desk_workers!
    create_deliveries!
  end

  private

  def create_admin_user!
    first_name, last_name = ENV.fetch('ADMIN_NAME', Faker::Name.name).dup.split(/\s+/, 2)

    User.new(
      first_name: first_name,
      last_name: last_name,
      email: ENV.fetch('ADMIN_EMAIL', 'admin@example.com').dup
    ) do |user|
      user.password = ENV.fetch('ADMIN_PASSWORD', Devise.friendly_token).dup
      user.confirmed_at = Time.zone.now
      user.activated_at = Time.zone.now
      user.user_roles.build([
        { title: 'DeskWorker' },
        { title: 'Admin' }
      ])
      user.save!
    end
  end

  def create_users!
    users_attributes = []

    20.times do
      password = Devise.friendly_token
      users_attributes << {
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        email: Faker::Internet.email,
        password: password,
        password_confirmation: password
      }
    end

    User.create!(users_attributes)
  end

  def create_desk_workers!
    user_ids = User.pluck(:id).sample(4)

    user_ids.each { |user_id| UserRole.create(user_id: user_id, title: 'DeskWorker') }
  end

  def create_deliveries!
    desk_worker_ids = User.desk_workers.pluck(:id)
    user_ids = User.pluck(:id)

    30.times do
      receipts_attributes = []

      (1..3).to_a.sample.times do
        receipts_attributes << {
          user_id: user_ids.sample,
          number_packages: (1..3).to_a.sample,
          comment: [1, 2].sample % 2 == 0 ? Faker::Lorem.sentence(2, true) : nil
        }
      end

      Delivery.create!(
        deliverer: Delivery::Deliverers.sample,
        user_id: desk_worker_ids.sample,
        receipts_attributes: receipts_attributes,
        created_at: Time.zone.now - (1..7).to_a.sample.days
      )
    end
  end
end
