class EmailInviteMailer < ApplicationMailer
    # send a signup email to the user, pass in the user object that   contains the user's email address
    default from: 'info@bananaapp.org'
      def send_reg_invite(user)
          @user = user
          mail(to: @user.email, subject: 'Your pending banana app food pickup account')
      end
  end