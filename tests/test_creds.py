import pytest
from _pytest.monkeypatch import MonkeyPatch
from dotenv import load_dotenv
from pydantic import ValidationError

from src.creds import CdfCreds

load_dotenv()


def test_creds_create_client() -> None:
    creds = CdfCreds()
    client = creds.create_client()
    assert client is not None


def test_creds_has_expected_fields() -> None:
    creds = CdfCreds()
    assert creds.tenant_id
    assert creds.client_id
    assert creds.client_secret


def test_missing_env_var_raises(monkeypatch: MonkeyPatch) -> None:
    monkeypatch.delenv("CDF_CLIENT_ID", raising=False)

    with pytest.raises(ValidationError):
        CdfCreds()


def test_token_url_format() -> None:
    creds = CdfCreds()
    assert creds.token_url.startswith("https://login.microsoftonline.com/")


def test_scopes_is_list() -> None:
    creds = CdfCreds()
    assert isinstance(creds.scopes, list)
