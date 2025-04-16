require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:unconfirmed_user) do
    FactoryBot.create(:user, password: password)
  end

  subject(:user) do
    FactoryBot.create(:user, :confirmed, password: password)
  end

  let(:new_email) { Faker::Internet.email }
  let(:password) { Faker::Internet.password(min_length: 12) }
  let(:ip) { IPAddr.new(Faker::Internet.ip_v4_address) }
  let(:redirect_url) { 'http://localhost:7777' }

  describe '#authenticate!' do
    before { user }

    it 'returns itself' do
      expect(User.authenticate!(user.email, password, ip, redirect_url)).to eq(user)
    end

    it 'tracks the sign in ip' do
      expect do
        User.authenticate!(user.email, password, ip, redirect_url)
        user.reload
      end.to change { user.current_sign_in_ip }.from(nil).to(ip)
    end

    it 'records the last sign in ip' do
      sign_in_ip = IPAddr.new(Faker::Internet.ip_v4_address)
      user.update!(current_sign_in_ip: sign_in_ip)
      expect do
        User.authenticate!(user.email, password, ip, redirect_url)
        user.reload
      end.to change { user.last_sign_in_ip }.from(nil).to(sign_in_ip)
    end

    it 'increments the sign in count' do
      expect do
        User.authenticate!(user.email, password, ip, redirect_url)
        user.reload
      end.to change { user.sign_in_count }.from(0).to(1)
    end

    context 'when the email has never been confirmed' do
      it 'throws an Auth::UnconfirmedError error' do
        expect { User.authenticate!(unconfirmed_user.email, password, ip, redirect_url) }.to raise_error(Auth::UnconfirmedError)
      end
    end

    context 'when the email has been changed and a confirmation is pending' do
      before { user.update!(email: new_email) }

      it 'throws an Auth::InvalidError error' do
        expect { User.authenticate!(new_email, password, ip, redirect_url) }.to raise_error(Auth::InvalidError)
      end
    end

    context 'when the password is invalid' do
      let(:wrong_password) { 'wrongpassword' }

      it 'throws an Auth::InvalidError error' do
        expect { User.authenticate!(user.email, wrong_password, ip, redirect_url) }.to raise_error(Auth::InvalidError)
      end

      it 'increments the number of failed attempts' do
        expect do
          begin User.authenticate!(user.email, wrong_password, ip, redirect_url); rescue; end
          user.reload
        end.to change { user.failed_attempts }.from(0).to(1)
      end

      context "when it's the last attempt" do
        before { user.update!(failed_attempts: User.maximum_attempts - 2) }

        it 'throws an Auth::LastAttemptError error' do
          expect { User.authenticate!(user.email, wrong_password, ip, redirect_url) }.to raise_error(Auth::LastAttemptError)
        end
      end

      context 'when the maximum of failed attempts has been reached' do
        before { user.update!(failed_attempts: User.maximum_attempts) }

        it 'locks the user' do
          expect do
            begin User.authenticate!(user.email, wrong_password, ip, redirect_url); rescue; end
            user.reload
          end.to change { user.access_locked? }.from(false).to(true)
        end
      end

      context 'when the user is locked' do
        before { user.lock_access! }

        it 'throws an Auth::Locked error' do
          expect { User.authenticate!(user.email, wrong_password, ip, redirect_url) }.to raise_error(Auth::LockedError)
        end
      end
    end
  end

  describe '#confirm!' do
    it 'returns true' do
      expect(unconfirmed_user.confirm!).to be true
    end

    context 'when the user is already confirmed' do
      it 'returns false' do
        expect(user.confirm!).to be false
      end
    end

    context 'when the confirmation period has expired' do
      before { unconfirmed_user.update(confirmation_sent_at: 3.days.ago) }

      it 'throws an AuthConfirmation::PeriodExpiredError error' do
        expect { unconfirmed_user.confirm! }.to raise_error(AuthConfirmation::PeriodExpiredError)
      end
    end
  end

  describe '#confirmed?' do
    it 'returns true' do
      expect(user.confirmed?).to be true
    end

    context 'when the user is unconfirmed' do
      it 'returns false' do
        expect(unconfirmed_user.confirmed?).to be false
      end
    end
  end

  describe '#after_update :notify_reconfirmation' do
    before { user }

    it 'sends a confirmation instructions email' do
      expect do
        user.confirmation_redirect_url = redirect_url
        user.email = new_email
        user.save
      end.to have_enqueued_mail(UserMailer, :confirmation_instructions_email)
    end
  end

  describe '#before_save :postpone_email_change_until_confirmation' do
    it 'keeps the email' do
      expect { user.update!(email: new_email) }.not_to change { user.email }
    end

    it 'sets the unconfirmed_email' do
      expect { user.update!(email: new_email) }.to change { user.unconfirmed_email }.from(nil).to(new_email)
    end
  end

  describe '#lock_access!' do
    it 'locks the access' do
      expect { user.lock_access! }.to change { user.access_locked? }.from(false).to(true)
    end

    it 'sends a unlock instructions email' do
      expect { user.lock_access! }.to have_enqueued_mail(UserMailer, :unlock_instructions_email)
    end
  end

  describe '#unlock_access!' do
    before { user.lock_access! }

    it 'unlocks the access' do
      expect { user.unlock_access! }.to change { user.access_locked? }.from(true).to(false)
    end
  end

  describe '#access_locked?' do
    it 'returns false' do
      expect(user.access_locked?).to be false
    end

    context 'when the access is locked' do
      before { user.lock_access! }

      it 'returns true' do
        expect(user.access_locked?).to be true
      end
    end
  end

  describe '#last_attempt?' do
    it 'returns false' do
      expect(user.last_attempt?).to be false
    end

    context 'when the last failed attempt has been reached' do
      before { user.update!(failed_attempts: User.maximum_attempts - 1) }

      it 'returns true' do
        expect(user.last_attempt?).to be true
      end
    end
  end

  describe '#attempts_exceeded?' do
    it 'returns false' do
      expect(user.attempts_exceeded?).to be false
    end

    context 'when the maximum of failed attempts has been reached' do
      before { user.update!(failed_attempts: User.maximum_attempts) }

      it 'returns true' do
        expect(user.attempts_exceeded?).to be true
      end
    end
  end

  describe '#increment_failed_attempts!' do
    it 'increments the number of failed attempts' do
      expect { user.increment_failed_attempts! }.to change { user.failed_attempts }.from(0).to(1)
    end

    context 'when the maximum of failed attempts has been reached' do
      before { user.update!(failed_attempts: User.maximum_attempts) }

      it 'locks the access' do
        expect { user.increment_failed_attempts! }.to change { user.access_locked? }.from(false).to(true)
      end
    end
  end

  describe '#lock_expired?' do
    it 'returns false' do
      expect(user.lock_expired?).to be false
    end

    context 'when the lock has expired' do
      before { user.update!(locked_at: 3.days.ago) }

      it 'returns true' do
        expect(user.lock_expired?).to be true
      end
    end
  end

  describe '#track_auth' do
    it 'sets the last sign in ip' do
      expect { user.track_auth(ip) }.to change { user.last_sign_in_ip }.from(nil).to(ip)
    end

    it 'sets the current sign in ip' do
      expect { user.track_auth(ip) }.to change { user.current_sign_in_ip }.from(nil).to(ip)
    end
  end

  describe '#after_create :notify_registration' do
    let(:new_user) { described_class.new({ name: Faker::Name.name, email: Faker::Internet.email, password: password }) }

    it 'sends a welcome email' do
      expect do
        new_user.confirmation_redirect_url = redirect_url
        new_user.save
      end.to have_enqueued_mail(UserMailer, :welcome_email)
    end
  end

  describe '#as_json' do
    let(:basic_data) { [ "id", "name", "email", "unconfirmed_email", "gender", "birthdate", "height_in_centimeters", "weight_in_grams", "activity_level" ] }

    it 'returns a Hash' do
      expect(user.as_json).to be_a Hash
    end

    it 'returns basic data' do
      expect(user.as_json.keys).to match_array(basic_data)
    end

    context 'with security data' do
      it 'returns basic data with security data' do
        expect(user.as_json(with_security_data: true).keys).to match_array(
          basic_data + [ "sign_in_count", "current_sign_in_at", "last_sign_in_at", "current_sign_in_ip", "last_sign_in_ip" ]
        )
      end
    end
  end
end
