import graphene


class TelegramGroupsType(graphene.ObjectType):
    title = graphene.String()
    id = graphene.Int()


class MembersResponse(graphene.ObjectType):
    id = graphene.Int()
    name = graphene.String()
    username = graphene.String()
    phone = graphene.String()


