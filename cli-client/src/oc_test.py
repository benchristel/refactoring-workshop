import oc
import types

def test_json():
    assert oc.parse_json('{"foo": "bar"}') == dict(foo='bar')
    assert oc.parse_json('["hello", "world"]') == ['hello', 'world']

def test_calling_a_command_and_getting_stdout():
    assert oc.stdout_of(['echo', 'hi']) == 'hi\n'

def test_client_can_receive_credentials_as_args():
    assert (oc.Client(username="bob", password="foo").creds()
        == oc.CredentialsFromArgs(username='bob', password='foo'))

def test_client_can_request_credentials_from_file():
    assert (oc.Client(ocrc_path="foo/bar").creds()
        == oc.CredentialsFromFile(path="foo/bar"))

def test_client_prefers_args_over_file_for_creds():
    client = oc.Client(
        username="bob",
        password="foo",
        ocrc_path="foo/bar")

    assert (client.creds() == oc.CredentialsFromArgs('bob', 'foo'))

def test_no_credentials():
    assert oc.Client().creds() == oc.NullCredentials()

def test_integration():
    assert (oc.Client(ocrc_path="fakes/ocrc").cabbages()
        == dict(args=['cabbages', '--username', 'elias', '--password', '`a$1""!`']))

def test_integration_through_global_function():
    assert oc.cabbages()['args'][0] == 'cabbages'

def test_integration_when_no_credentials():
    assert (oc.Client(ocrc_path="i-do-not-exist").cabbages()
        == dict(args=['cabbages']))

def test_integration_when_credentials_passed_as_args():
    assert (oc.Client(username="a", password="b").cabbages()
        == dict(args=['cabbages', '--username', 'a', '--password', 'b']))
