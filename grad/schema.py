import graphene

class Query(graphene.ObjectType):
    test = graphene.String(default_value="test")


schema = graphene.Schema(query=Query)