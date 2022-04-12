import graphene
from adder.mutations import(
    RequestTelegramAuthCode, SubmitTelegramAuthCode, TelegramAuthLogout, TelegramTestSession)


class Query(graphene.ObjectType):
    test = graphene.String(default_value="test")


class Mutations(graphene.ObjectType):
    request_auth_code = RequestTelegramAuthCode.Field(
        description="Request telegram auth code")
    submit_auth_code = SubmitTelegramAuthCode.Field(
        description="Submit Authorization code")
    telegram_logout = TelegramAuthLogout.Field(
        description="Logout form telegram")
    check_user_status = TelegramTestSession.Field(
        description="Check user telegram status with username")


schema = graphene.Schema(query=Query, mutation=Mutations)
