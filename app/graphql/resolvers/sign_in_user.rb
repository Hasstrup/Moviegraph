class Resolvers::SignInUser < GraphQL::Function 
    argument :details, !Types::AuthProviderEmailInput
    
    type do 
        name "SignInPayload"
        field :token, types.String
        field :user, Types::UserType
    end

    def call (obj, args, context)
        input = args[:details]
        return unless input
        user = User.find_by(email: input[:email])
        return unless user && user.authenticate(input[:password])
        crypt = ActiveSupport::MessageEncryptor.new(Rails.application.secrets.secret_key_base.byteslice(0..31))
        token = crypt.encrypt_and_sign("user-id:#{ user.id }")
        OpenStruct.new({ token: token, user: user })
    end 
end 