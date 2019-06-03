require 'rails_helper'

RSpec.describe 'user profile', type: :feature do
  before :each do

    @user = create(:user)
    create(:address, user: @user)
    create(:address, user: @user)
  end

  describe 'registered user visits their profile' do
    it 'shows user information' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit profile_path

      within '#profile-data' do
        expect(page).to have_content("Role: #{@user.role}")
        expect(page).to have_content("Email: #{@user.email}")
        within '#address-details' do
          @user.addresses.each do |address|
            expect(page).to have_content("Address: #{address.street_address}")
            expect(page).to have_content("#{address.city}, #{address.state} #{address.zip}")
          end
        end
        expect(page).to have_link('Edit Profile Data')
      end
    end
  end

  describe 'registered user edits their profile' do
    describe 'edit user form' do
      it 'pre-fills form with all but password information' do
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

        visit profile_path

        click_link 'Edit'
        expect(current_path).to eq('/profile/edit')
        expect(find_field('Name').value).to eq(@user.name)
        expect(find_field('Email').value).to eq(@user.email)
        expect(find_field('Password').value).to eq(nil)
        expect(find_field('Password confirmation').value).to eq(nil)
        @user.addresses.each do |address|
          within "#address-#{address.id}" do
            expect(find_field('Street address').value).to eq(address.street_address)
            expect(find_field('City').value).to eq(address.city)
            expect(find_field('State').value).to eq(address.state)
            expect(find_field('Zip').value).to eq(address.zip)
          end
        end
      end
    end

    describe 'user information is updated' do
      before :each do
        @updated_name = 'Updated Name'
        @updated_email = 'updated_email@example.com'
        @updated_address = 'newest address'
        @updated_city = 'new new york'
        @updated_state = 'S. California'
        @updated_zip = '33333'
        @updated_password = 'newandextrasecure'
      end

      describe 'succeeds with allowable updates' do
        scenario 'all attributes are updated' do
          login_as(@user)
          old_digest = @user.password_digest

          visit edit_profile_path
          fill_in :user_name, with: @updated_name
          fill_in :user_email, with: @updated_email
          fill_in :user_password, with: @updated_password
          fill_in :user_password_confirmation, with: @updated_password
          @user.addresses.each do |address|
            within "#address-#{address.id}" do
              fill_in 'Street address', with: @updated_address
              fill_in 'City', with: @updated_city
              fill_in 'State', with: @updated_state
              fill_in 'Zip', with: @updated_zip
            end
          end

          click_button 'Submit'

          updated_user = User.find(@user.id)

          expect(current_path).to eq(profile_path)
          expect(page).to have_content("Your profile has been updated")
          expect(page).to have_content("#{@updated_name}")
          within '#profile-data' do
            expect(page).to have_content("Email: #{@updated_email}")
            within '#address-details' do
              expect(page).to have_content("#{@updated_address}")
              expect(page).to have_content("#{@updated_city}, #{@updated_state} #{@updated_zip}")
            end
          end
          expect(updated_user.password_digest).to_not eq(old_digest)
        end
      end
      scenario 'works if no password is given' do
        login_as(@user)
        old_digest = @user.password_digest

        visit edit_profile_path

        fill_in :user_name, with: @updated_name
        fill_in :user_email, with: @updated_email
        within "#address-#{@user.addresses.first.id}" do
          fill_in 'Street address', with: @updated_address
          fill_in 'City', with: @updated_city
          fill_in 'State', with: @updated_state
          fill_in 'Zip', with: @updated_zip
        end

        click_button 'Submit'

        updated_user = User.find(@user.id)

        expect(current_path).to eq(profile_path)
        expect(page).to have_content("Your profile has been updated")
        expect(page).to have_content("#{@updated_name}")
        within '#profile-data' do
          expect(page).to have_content("Email: #{@updated_email}")
          within '#address-details' do
            expect(page).to have_content("#{@updated_address}")
            expect(page).to have_content("#{@updated_city}, #{@updated_state} #{@updated_zip}")
          end
        end
        expect(updated_user.password_digest).to eq(old_digest)
      end
    end
  end

  it 'fails with non-unique email address change' do
    create(:user, email: 'megan@example.com')
    login_as(@user)

    visit edit_profile_path

    fill_in :user_email, with: 'megan@example.com'

    click_button 'Submit'

    expect(page).to have_content("Email has already been taken")
  end

  it 'adds new address' do
    login_as(@user)

    visit profile_path

    expect(page).to have_content('Add Address')
    click_on 'Add Address'
    expect(current_path).to eq(new_profile_address_path)

    fill_in 'State', with: 'Florida'
    fill_in 'City', with: 'Gainesville'
    fill_in 'Zip', with: '90210'
    fill_in 'Street address', with: '123 wonderful st'
    fill_in 'Nickname', with: 'Summer'

    click_on 'Submit'
    expect(current_path).to eq(profile_path)
  end

  it 'deletes an address' do
    login_as(@user)

    visit profile_path

    click_on 'Add Address'

    fill_in 'State', with: 'Florida'
    fill_in 'City', with: 'Gainesville'
    fill_in 'Zip', with: '90210'
    fill_in 'Street address', with: '123 wonderful st'
    fill_in 'Nickname', with: 'Summer'

    click_on 'Submit'

    @user.addresses.each do |address|
      within "#address-#{address.id}" do
        expect(page).to have_link 'Delete Address'
      end
    end

    within "#address-#{@user.addresses.last.id}" do
      click_on "Delete Address"
    end

    expect(current_path).to eq(profile_path)
    expect(page).to_not have_content('Florida')
    expect(page).to_not have_content('Gainesville')
    expect(page).to_not have_content('123 wonderful st')
  end

  it 'doesnt delete an address that was part of completed order' do
    login_as(@user)

    visit profile_path

    click_on 'Add Address'

    fill_in 'State', with: 'Florida'
    fill_in 'City', with: 'Gainesville'
    fill_in 'Zip', with: '90210'
    fill_in 'Street address', with: '123 wonderful st'
    fill_in 'Nickname', with: 'Summer'

    click_on 'Submit'

    @user.addresses.each do |address|
      within "#address-#{address.id}" do
        expect(page).to have_link 'Delete Address'
      end
    end

    last_addy = @user.addresses.last
    create(:order, status: :packaged, address: last_addy)
    visit profile_path

    within "#address-#{@user.addresses.last.id}" do
      expect(page).to_not have_link("Delete Address")
    end

    expect(current_path).to eq(profile_path)
    expect(page).to have_content('Florida')
    expect(page).to have_content('Gainesville')
    expect(page).to have_content('123 wonderful st')
  end

end
