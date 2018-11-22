class Resolvers::CreateLink < GraphQL::Function
    argument :description, !types.String
    argument :url, !types.String

    type Types::LinkType
    # _obj - is parent object, which in this case is nil
    # args - are the arguments passed
    # _ctx - is the GraphQL context
    def call(_obj, args, _ctx)
      Link.create!(
        description: args[:description],
        url: args[:url],
      )
    end
  end