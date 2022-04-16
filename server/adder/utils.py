import csv
from telethon.tl.types import InputPeerUser, InputPeerChannel
from telethon.tl.functions.channels import InviteToChannelRequest
from telethon.errors import PeerFloodError, UserPrivacyRestrictedError


def add_to_grp(client, mode="uname", data=None, uname=None, grid=None, grhash=None):
    try:
        if (uname is not None) and (mode == "uname"):
            user_to_add = client.get_input_entity(uname)
        # get user_to_add with hash not username
        elif (data is not None) and (mode == "hash"):
            user_to_add = InputPeerUser(data["uid"], int(data["uhash"]))

        target_group_entity = InputPeerChannel(grid, int(grhash))
        target_grp_ent = InputPeerChannel(grid, int(grhash))
        client(InviteToChannelRequest(target_grp_ent, [user_to_add]))
        return {"added": True}

    except PeerFloodError as e:
        print("Error Fooling cmnr")
        print("remove client: ")
        client.disconnect()
        # filter_clients.remove(current_client)
        return {"added": False}

    except UserPrivacyRestrictedError:
        print("Error Privacy")
    except Exception as e:
        print(e)
        return {"added": False}


def cleanCSVData(input_f):
    users = []
    with open(input_f, encoding="UTF-8") as f:
        rows = csv.reader(f, delimiter=",", lineterminator="\n")
        next(rows, None)
        for row in rows:
            user = {}
            user["username"] = row[2]
            user["id"] = int(row[0])
            user["access_hash"] = row[4]
            # user["name"] = row[3]
            users.append(user)

    return users