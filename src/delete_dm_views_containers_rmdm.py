from cognite.client import CogniteClient
from dotenv import load_dotenv

from src.creds import CdfCreds

load_dotenv()


def delete_all_in_space(client: CogniteClient, space: str) -> None:
    del_dm = client.data_modeling.data_models.list(space=space)
    res_dm = client.data_modeling.data_models.delete(del_dm)
    print(f"Deleted {len(res_dm)} data models")
    del_views = client.data_modeling.views.list(space=space, limit=-1)
    res_views = client.data_modeling.views.delete(del_views)
    print(f"Deleted {len(res_views)} views")
    del_containers = client.data_modeling.containers.list(space=space, limit=-1)
    res_containers = client.data_modeling.containers.delete(del_containers)
    print(f"Deleted {len(res_containers)} containers")


def main() -> None:
    creds = CdfCreds()
    client = creds.create_client()

    print("Authenticated to project:", creds.CDF_PROJECT)
    delete_all_in_space(client, "rmdm")


if __name__ == "__main__":
    main()
