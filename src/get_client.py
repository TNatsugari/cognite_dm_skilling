from cognite.client import ClientConfig, CogniteClient
from cognite.client.credentials import OAuthClientCredentials
from dotenv import dotenv_values


def get_client(env_file_path: str) -> CogniteClient:
    config = dotenv_values(env_file_path)

    oauth_provider = OAuthClientCredentials(
        token_url=config["TOKEN_URL"],
        client_id=config["IDP_CLIENT_ID"],
        client_secret=config["IDP_CLIENT_SECRET"],
        scopes=None,
    )

    client_config = ClientConfig(
        project=config["CDF_PROJECT"],
        client_name="transformations_run",
        credentials=oauth_provider,
        base_url=config["CDF_URL"],
        timeout=2,
    )

    client = CogniteClient(config=client_config)
    client.iam.token.inspect()
    print(f"Connected to project {client.config.project}")
    return client


if __name__ == "__main__":
    get_client()
